class Indocker::Actions::ConfigurationLoader
  include Indocker::Import[
    "core.registry_store",
    "core.image_store",
    "core.configuration_store",
    "artifacts_sync.artifacts_updater",
    "tools.logger",
    "shell.local_shell",
    "ui",
    "configs"
  ]

  Contract Hash => Any
  def call(options)
    root_path   = options[:path] || File.join(Dir.pwd, configs.indocker_dirname)
    images_path = options[:images_path] || File.join(root_path, configs.images_dirname)
    infra_path  = options[:infra_path]  || File.join(root_path, configs.infra_dirname)
    configurations_path  = options[:configurations_path]  || File.join(root_path, configs.configurations_dirname)
    configuration_name   = options[:configuration] || :_default_

    logger.info "Launching indocker with:"
    logger.info "  Root path: #{root_path.to_s.yellow}"
    logger.info "  Images path: #{images_path.to_s.yellow}"
    logger.info "  Infrastructure path: #{infra_path.to_s.yellow}"
    logger.info "  Configurations path: #{configurations_path.to_s.yellow}"
    logger.info "  Configuration name: #{configuration_name.to_s.yellow}"

    configuration_store.define(:_default_)
    configuration_store.load_definitions(configurations_path)
    Indocker.set_configuration_name(configuration_name)

    load_infrastructure(infra_path)

    ui.create_task("Updating artifacts") do |task|
      artifacts_updater.update(local_shell, Indocker.current_configuration.artifacts)
    end

    ui.create_task("Loading image definitions") do |task|
      files = image_store.load_definitions(images_path)
      task.update_title("Loaded #{files.count} image definitions")
    end
  end

  def load_infrastructure(infra_path)
    local_shell.recursive_list_files(infra_path).each do |path|
      require(path)
    end
  end
end