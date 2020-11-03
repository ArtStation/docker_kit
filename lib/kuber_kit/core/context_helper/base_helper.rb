class KuberKit::Core::ContextHelper::BaseHelper
  CONTRACT = RespondTo[:get_binding]

  attr_reader :shell, :artifact_store, :image_store, :env_file_reader

  def initialize(image_store:, artifact_store:, shell:, env_file_reader:)
    @image_store      = image_store
    @artifact_store   = artifact_store
    @shell            = shell
    @env_file_reader  = env_file_reader
  end

  def image_url(image_name)
    image = @image_store.get_image(image_name.to_sym)

    image.remote_registry_url
  end

  def artifact_path(name, file_name = nil)
    artifact = @artifact_store.get(name.to_sym)
    [artifact.cloned_path, file_name].compact.join("/")
  end

  def env_file(env_file_name)
    @env_file_reader.call(@shell, env_file_name)
  end

  def configuration_name
    KuberKit.current_configuration.name
  end

  def get_binding
    binding
  end
end