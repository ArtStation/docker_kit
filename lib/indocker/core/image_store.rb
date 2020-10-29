class Indocker::Core::ImageStore
  NotFoundError = Class.new(Indocker::Error)
  AlreadyAddedError = Class.new(Indocker::Error)

  include Indocker::Import[
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
    @@image_definitions ||= {}

    unless @@image_definitions[image_definition.image_name].nil?
      raise AlreadyAddedError, "image #{image_definition.image_name} was already added"
    end

    @@image_definitions[image_definition.image_name] = image_definition
  end

  def get_definition(image_name)
    @@image_definitions ||= {}

    if @@image_definitions[image_name].nil?
      raise NotFoundError, "image #{image_name} not found"
    end

    @@image_definitions[image_name]
  end

  def get_image(image_name)
    definition = get_definition(image_name)

    image_factory.create(definition)
  end

  def load_definitions(dir_path)
    files = local_shell.recursive_list_files(dir_path, name: "image.rb").each do |path|
      load_definition(path)
    end
  rescue Indocker::Shell::AbstractShell::DirNotFoundError
    logger.warn("Directory with images not found: #{dir_path}")
    []
  end

  def load_definition(file_path)
    require(file_path)
  end

  def reset!
    @@image_definitions = {}
  end
end