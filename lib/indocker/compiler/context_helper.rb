class Indocker::Compiler::ContextHelper
  attr_reader :image_store, :artifact_store

  def initialize(image_store:, artifact_store:)
    @image_store = image_store
    @artifact_store = artifact_store
  end

  def image_url(image_name)
    image = image_store.get_image(image_name)

    image.remote_registry_url
  end

  def artifact_path(name)
    repo = artifact_store.get(name)
    repo.cloned_path
  end

  def get_binding
    binding
  end
end