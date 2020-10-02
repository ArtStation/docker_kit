class Indocker::Compiler::ContextHelper
  attr_reader :image_store

  def initialize(image_store:)
    @image_store = image_store
  end

  def image_url(image_name)
    image = image_store.get_image(image_name)

    image.remote_registry_url
  end

  def get_binding
    binding
  end
end