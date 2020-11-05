class KuberKit::Core::ImageStore
  include KuberKit::Import[
    "core.image_factory",
    "core.image_definition_factory",
    "shell.local_shell",
    "tools.logger"
  ]

  def define(image_name, image_dir = nil)
    definition = image_definition_factory.create(image_name, image_dir)
    add_definition(definition)
    definition
  end

  def add_definition(image_definition)
    definitions_store.add(image_definition.image_name, image_definition)
  end

  Contract Symbol => Any
  def get_definition(image_name)
    definitions_store.get(image_name)
  end

  Contract Symbol => Any
  def get_image(image_name)
    definition = get_definition(image_name)

    image_factory.create(definition)
  end

  def load_definitions(dir_path)
    files = local_shell.recursive_list_files(dir_path, name: "image.rb").each do |path|
      load_definition(path)
    end
  rescue KuberKit::Shell::AbstractShell::DirNotFoundError
    logger.warn("Directory with images not found: #{dir_path}")
    []
  end

  def load_definition(file_path)
    require(file_path)
  end

  def reset!
    definitions_store.reset!
  end

  private
    def definitions_store
      @@definitions_store ||= KuberKit::Core::Store.new(KuberKit::Core::ImageDefinition)
    end
end