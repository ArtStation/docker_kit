class Indocker::Compiler::ContextHelper
  attr_reader :image_store, :repository_store

  def initialize(image_store:, repository_store:)
    @image_store = image_store
    @repository_store = repository_store
  end

  def image_url(image_name)
    image = image_store.get_image(image_name)

    image.remote_registry_url
  end

  def repository_path(name)
    repo = repository_store.get(name)
    repo.cloned_path
  end

  def get_binding
    binding
  end
end