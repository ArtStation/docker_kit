class KuberKit::Core::ContextHelper::ImageHelper < KuberKit::Core::ContextHelper::BaseHelper
  def initialize(image_store:, artifact_store:, shell:, env_file_reader:, image:)
    super(
      image_store:      image_store, 
      artifact_store:   artifact_store, 
      shell:            shell,
      env_file_reader:  env_file_reader
    )
    @image = image
  end

  def image_name
    @image.name.to_s
  end

  def build_vars
    KuberKit::Core::ContextHelper::ContextVars.new(@image.build_vars)
  end
end