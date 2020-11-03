class KuberKit::Core::ContextHelper::ContextHelperFactory
  include KuberKit::Import[
    "core.image_store",
    "core.artifact_store",
    env_file_reader: "env_file_reader.action_handler"
  ]

  def build_image_context(shell)
    KuberKit::Core::ContextHelper::ImageHelper.new(
      image_store:      image_store,
      artifact_store:   artifact_store,
      shell:            shell,
      env_file_reader:  env_file_reader
    )
  end

  def build_service_context(shell, service)
    KuberKit::Core::ContextHelper::ServiceHelper.new(
      image_store:      image_store,
      artifact_store:   artifact_store,
      shell:            shell,
      env_file_reader:  env_file_reader,
      service:          service,
    )
  end
end