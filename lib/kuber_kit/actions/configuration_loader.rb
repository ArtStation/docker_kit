class KuberKit::Actions::ConfigurationLoader
  include KuberKit::Import[
    "core.registry_store",
    "core.image_store",
    "core.service_store",
    "core.configuration_store",
    "artifacts_sync.artifacts_updater",
    "tools.logger",
    "shell.local_shell",
    "ui",
    "configs"
  ]

  Contract Hash => Any
  def call(options)
    root_path     = options[:path] || File.join(Dir.pwd, configs.kuber_kit_dirname)
    images_path   = options[:images_path] || File.join(root_path, configs.images_dirname)
    services_path = options[:services_path] || File.join(root_path, configs.services_dirname)
    infra_path    = options[:infra_path]  || File.join(root_path, configs.infra_dirname)
    configurations_path  = options[:configurations_path]  || File.join(root_path, configs.configurations_dirname)
    configuration_name   = options[:configuration]

    logger.info "Launching kuber_kit with:"
    logger.info "  Root path: #{root_path.to_s.yellow}"
    logger.info "  Images path: #{images_path.to_s.yellow}"
    logger.info "  Services path: #{services_path.to_s.yellow}"
    logger.info "  Infrastructure path: #{infra_path.to_s.yellow}"
    logger.info "  Configurations path: #{configurations_path.to_s.yellow}"
    logger.info "  Configuration name: #{configuration_name.to_s.yellow}"

    unless File.exists?(root_path)
      ui.print_warning "WARNING", "KuberKit root path #{root_path} doesn't exist. You may want to pass it --path parameter."
    end

    load_configurations(configurations_path, configuration_name)
    load_infrastructure(infra_path)

    ui.create_task("Updating artifacts") do |task|
      artifacts = KuberKit.current_configuration.artifacts.values
      artifacts_updater.update(local_shell, artifacts)
      task.update_title("Updated #{artifacts.count} artifacts")
    end

    ui.create_task("Loading image definitions") do |task|
      files = image_store.load_definitions(images_path)
      task.update_title("Loaded #{files.count} image definitions")
    end

    ui.create_task("Loading service definitions") do |task|
      files = service_store.load_definitions(services_path)
      task.update_title("Loaded #{files.count} service definitions")
    end
  end
  
  def load_configurations(configurations_path, configuration_name)
    configuration_store.load_definitions(configurations_path)

    if configuration_store.count.zero?
      configuration_store.define(:_default_)
      configuration_name ||= :_default_
    end

    if configuration_store.count == 1 && configuration_name.nil?
      first_configurations = configuration_store.all_definitions.values.first
      configuration_name   = first_configurations.configuration_name
    end

    if configuration_store.count > 1 && configuration_name.nil?
      raise KuberKit::Error, "Please set configuration name using -C option"
    end

    KuberKit.set_configuration_name(configuration_name)
  end

  def load_infrastructure(infra_path)
    local_shell.recursive_list_files(infra_path).each do |path|
      require(path)
    end
  rescue KuberKit::Shell::AbstractShell::DirNotFoundError
    logger.warn("Directory with infrastructure not found: #{infra_path}")
  end
end