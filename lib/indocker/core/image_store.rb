class Indocker::Core::ImageStore
  NotFoundError = Class.new(StandardError)
  AlreadyAddedError = Class.new(StandardError)

  include Indocker::Import["image_factory"]
  include Indocker::Import["image_definition_factory"]

  def define(image_name)
    definition = image_definition_factory.create(image_name)
    add_definition(definition)
    definition
  end

  def add_definition(image_definition)
    @image_definitions ||= {}

    raise AlreadyAddedError unless @image_definitions[image_definition.image_name].nil?

    @image_definitions[image_definition.image_name] = image_definition
  end

  def get_definition(image_name)
    @image_definitions ||= {}

    raise NotFoundError if @image_definitions[image_name].nil?

    @image_definitions[image_name]
  end

  def get_image(image_name)
    definition = get_definition(image_name)

    image_factory.create(definition)
  end
end