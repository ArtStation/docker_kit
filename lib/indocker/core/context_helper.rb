class Indocker::Core::ContextHelper
  attr_reader :shell, :artifact_store, :image_store

  def initialize(image_store:, artifact_store:, shell:)
    @image_store    = image_store
    @artifact_store = artifact_store
    @shell          = shell
  end

  def image_url(image_name)
    image = @image_store.get_image(image_name)

    image.remote_registry_url
  end

  def artifact_path(name, file_name = nil)
    artifact = @artifact_store.get(name)
    [artifact.cloned_path, file_name].compact.join("/")
  end

  def get_binding
    binding
  end
end