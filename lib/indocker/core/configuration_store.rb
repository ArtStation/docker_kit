class Indocker::Core::ConfigurationStore
  NotFoundError = Class.new(Indocker::NotFoundError)
  AlreadyAddedError = Class.new(Indocker::Error)

  include Indocker::Import[
    "core.configuration_factory",
    "core.configuration_definition_factory",
    "shell.local_shell",
    "tools.logger"
  ]

  def define(configuration_name)
    definition = configuration_definition_factory.create(configuration_name)
    add_definition(definition)
    definition
  end

  def add_definition(configuration_definition)
    @@configuration_definitions ||= {}

    unless @@configuration_definitions[configuration_definition.configuration_name].nil?
      raise AlreadyAddedError, "image #{configuration_definition.configuration_name} was already added"
    end

    @@configuration_definitions[configuration_definition.configuration_name] = configuration_definition
  end

  def get_definition(configuration_name)
    @@configuration_definitions ||= {}

    if @@configuration_definitions[configuration_name].nil?
      raise NotFoundError, "configuration #{configuration_name} not found"
    end

    @@configuration_definitions[configuration_name]
  end

  def get_configuration(configuration_name)
    definition = get_definition(configuration_name)

    configuration_factory.create(definition)
  end

  def load_definitions(dir_path)
    files = local_shell.recursive_list_files(dir_path).each do |path|
      load_definition(path)
    end
  rescue Indocker::Shell::AbstractShell::DirNotFoundError
    logger.warn("Directory with configurations not found: #{dir_path}")
    []
  end

  def load_definition(file_path)
    require(file_path)
  end

  def reset!
    @@configuration_definitions = {}
  end
end