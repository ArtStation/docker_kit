class KuberKit::Core::ServiceStore
  include KuberKit::Import[
    "core.service_factory",
    "core.service_definition_factory",
    "shell.local_shell",
    "ui",
  ]

  def define(service_name)
    definition = service_definition_factory.create(service_name)
    add_definition(definition)
    definition
  end

  def add_definition(service_definition)
    definitions_store.add(service_definition.service_name, service_definition)
  end

  Contract Symbol => Any
  def get_definition(service_name)
    definitions_store.get(service_name)
  end

  Contract Symbol => Any
  def get_service(service_name)
    definition = get_definition(service_name)

    service_factory.create(definition)
  end

  def load_definitions(dir_path)
    files = local_shell.recursive_list_files(dir_path, name: "*.rb").each do |path|
      load_definition(path)
    end
  rescue KuberKit::Shell::AbstractShell::DirNotFoundError
    ui.print_warning("ServiceStore", "Directory with services not found: #{dir_path}")
    []
  end

  def load_definition(file_path)
    require(file_path)
  end

  def reset!
    definitions_store.reset!
  end

  def count
    definitions_store.size
  end

  def all_definitions
    definitions_store.items
  end

  def exists?(service_name)
    definitions_store.exists?(service_name)
  end

  private
    def definitions_store
      @@definitions_store ||= KuberKit::Core::Store.new(KuberKit::Core::ServiceDefinition)
    end
end