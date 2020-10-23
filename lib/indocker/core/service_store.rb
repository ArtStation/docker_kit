class Indocker::Core::ServiceStore
  NotFoundError = Class.new(Indocker::Error)
  AlreadyAddedError = Class.new(Indocker::Error)

  include Indocker::Import[
    "core.service_factory",
    "core.service_definition_factory",
    "shell.local_shell"
  ]

  def define(service_name)
    definition = service_definition_factory.create(service_name)
    add_definition(definition)
    definition
  end

  def add_definition(service_definition)
    @@service_definitions ||= {}

    unless @@service_definitions[service_definition.service_name].nil?
      raise AlreadyAddedError, "service #{service_definition.service_name} was already added"
    end

    @@service_definitions[service_definition.service_name] = service_definition
  end

  def get_definition(service_name)
    @@service_definitions ||= {}

    if @@service_definitions[service_name].nil?
      raise NotFoundError, "service #{service_name} not found"
    end

    @@service_definitions[service_name]
  end

  def get_service(service_name)
    definition = get_definition(service_name)

    service_factory.create(definition)
  end

  def load_definitions(dir_path)
    files = local_shell.recursive_list_files(dir_path, name: "*.rb").each do |path|
      load_definition(path)
    end
  end

  def load_definition(file_path)
    require(file_path)
  end

  def reset!
    @@service_definitions = {}
  end
end