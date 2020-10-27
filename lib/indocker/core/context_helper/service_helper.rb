class Indocker::Core::ContextHelper::ServiceHelper < Indocker::Core::ContextHelper::BaseHelper
  def initialize(image_store:, artifact_store:, shell:, service:)
    super(
      image_store:    image_store, 
      artifact_store: artifact_store, 
      shell:          shell
    )
    @service = service
  end
end