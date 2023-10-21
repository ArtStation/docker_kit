class KuberKit::Core::ContextHelper::ContextHelperFactory
  include KuberKit::Import[
    "core.image_store",
    "core.artifact_store",
    template_renderer: "template_reader.renderer",
    env_file_reader:   "env_file_reader.action_handler"
  ]

  def build_image_context(shell, image)
    KuberKit::Core::ContextHelper::ImageHelper.new(
      image_store:      image_store,
      artifact_store:   artifact_store,
      shell:            shell,
      env_file_reader:  env_file_reader,
      image:            image
    )
  end

  def build_service_context(shell, service)
    KuberKit::Core::ContextHelper::ServiceHelper.new(
      image_store:      image_store,
      artifact_store:   artifact_store,
      shell:            shell,
      env_file_reader:  env_file_reader,
      service:          service,
      template_renderer: template_renderer
    )
  end
end