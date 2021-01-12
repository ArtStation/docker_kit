class KuberKit::Core::ConfigurationStore
  include KuberKit::Import[
    "core.configuration_factory",
    "core.configuration_definition_factory",
    "shell.local_shell",
    "ui"
  ]

  def define(configuration_name)
    definition = configuration_definition_factory.create(configuration_name)
    add_definition(definition)
    definition
  end

  def add_definition(configuration_definition)
    definitions_store.add(configuration_definition.configuration_name, configuration_definition)
  end

  Contract Symbol => Any
  def get_definition(configuration_name)
    definitions_store.get(configuration_name)
  end

  Contract Symbol => Any
  def get_configuration(configuration_name)
    definition = get_definition(configuration_name)

    configuration_factory.create(definition)
  end

  def load_definitions(dir_path)
    files = local_shell.recursive_list_files(dir_path).each do |path|
      load_definition(path)
    end
  rescue KuberKit::Shell::AbstractShell::DirNotFoundError
    ui.print_warning("ConfigurationStore", "Directory with configurations not found: #{dir_path}")
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

  def exists?(configuration_name)
    definitions_store.exists?(configuration_name)
  end

  def all_definitions
    definitions_store.items
  end

  private
    def definitions_store
      @@definitions_store ||= KuberKit::Core::Store.new(KuberKit::Core::ConfigurationDefinition)
    end
end