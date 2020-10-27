class Indocker::Core::ContextHelper::ContextHelperFactory
  include Indocker::Import[
    "core.image_store",
    "core.artifact_store"
  ]

  def build_image_context(shell)
    Indocker::Core::ContextHelper::ImageHelper.new(
      image_store:    image_store,
      artifact_store: artifact_store,
      shell:          shell
    )
  end

  def build_service_context(shell, service)
    Indocker::Core::ContextHelper::ServiceHelper.new(
      image_store:    image_store,
      artifact_store: artifact_store,
      shell:          shell,
      service:        service
    )
  end
end