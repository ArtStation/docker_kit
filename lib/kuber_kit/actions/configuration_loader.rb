class KuberKit::Actions::ConfigurationLoader
  include KuberKit::Import[
    "core.registry_store",
    "core.image_store",
    "core.service_store",
    "core.configuration_store",
    "tools.workdir_detector",
    "artifacts_sync.artifact_updater",
    "shell.local_shell",
    "ui",
    "configs"
  ]

  Contract Hash => Any
  def call(options)
    root_path     = workdir_detector.call(options)
    images_path   = options[:images_path] || File.join(root_path, configs.images_dirname)
    services_path = options[:services_path] || File.join(root_path, configs.services_dirname)
    infra_path    = options[:infra_path]  || File.join(root_path, configs.infra_dirname)
    configurations_path  = options[:configurations_path]  || File.join(root_path, configs.configurations_dirname)
    configuration_name   = options[:configuration] || ENV["KUBER_KIT_CONFIGURATION"]
    load_inventory = options.fetch(:load_inventory, true)

    ui.print_debug "ConfigurationLoader", "Launching kuber_kit with:"
    ui.print_debug "ConfigurationLoader", "  Root path: #{root_path.to_s.yellow}"
    ui.print_debug "ConfigurationLoader", "  Images path: #{images_path.to_s.yellow}"
    ui.print_debug "ConfigurationLoader", "  Services path: #{services_path.to_s.yellow}"
    ui.print_debug "ConfigurationLoader", "  Infrastructure path: #{infra_path.to_s.yellow}"
    ui.print_debug "ConfigurationLoader", "  Configurations path: #{configurations_path.to_s.yellow}"
    ui.print_debug "ConfigurationLoader", "  Configuration name: #{configuration_name.to_s.yellow}"

    ui.print_info("Logs", "See logs at: #{configs.log_file_path}")

    unless File.exists?(root_path)
      ui.print_warning "ConfigurationLoader", "KuberKit root path #{root_path} doesn't exist. You may want to pass it --path parameter."
    end

    if Gem::Version.new(KuberKit::VERSION) < Gem::Version.new(configs.kuber_kit_min_version)
      raise KuberKit::Error, "The minimal required kuber_kit version is #{configs.kuber_kit_min_version}"
    end

    load_configurations(configurations_path, configuration_name)
    load_infrastructure(infra_path)

    if load_inventory || KuberKit.current_configuration.kubeconfig_path.is_a?(KuberKit::Core::ArtifactPath)
      update_artifacts(KuberKit.current_configuration.artifacts.values)
    end

    if load_inventory
      ui.create_task("Loading image definitions") do |task|
        files = image_store.load_definitions(images_path)

        configs.additional_images_paths.each do |path|
          files += image_store.load_definitions(path)
        end

        task.update_title("Loaded #{files.count} image definitions")
      end

      ui.create_task("Loading service definitions") do |task|
        files = service_store.load_definitions(services_path)
        task.update_title("Loaded #{files.count} service definitions")
      end
    end
    
    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
  
  def load_configurations(configurations_path, configuration_name)
    configuration_store.load_definitions(configurations_path)

    if configuration_store.count.zero?
      configuration_store.define(:_default_)
      configuration_name ||= :_default_
    end

    all_configurations = configuration_store.all_definitions.values
    if configuration_store.count == 1 && configuration_name.nil?
      first_configurations = all_configurations.first
      configuration_name   = first_configurations.configuration_name
    end

    if configuration_store.count > 1 && configuration_name.nil?
      options = all_configurations.map(&:configuration_name).map(&:to_s)
      configuration_name = ui.prompt("Please select configuration name (or set it using -C option)", options)
    end

    KuberKit.set_configuration_name(configuration_name)
  end

  def load_infrastructure(infra_path)
    local_shell.recursive_list_files(infra_path).each do |path|
      require(path)
    end
  rescue KuberKit::Shell::AbstractShell::DirNotFoundError
    ui.print_warning("ConfigurationLoader", "Directory with infrastructure not found: #{infra_path}")
  end

  def update_artifacts(artifacts)
    # Skip local artifacts, they sometimes produce error in CLI::UI::SpinGroup task,
    # because the task is executed too quickly
    not_local_artifacts = artifacts.reject{ |a| a.is_a?(KuberKit::Core::Artifacts::Local) }

    return unless not_local_artifacts.any?

    artifact_task_group = ui.create_task_group
    not_local_artifacts.each do |artifact|
      artifact_task_group.add("Updating #{artifact.name.to_s.yellow} [#{artifact.sync_description.cyan}]") do |task|
        artifact_updater.update(local_shell, artifact)
        task.update_title("Updating #{artifact.name.to_s.green} [#{artifact.sync_description.cyan}]")
      end
    end
    artifact_task_group.wait
  end
end