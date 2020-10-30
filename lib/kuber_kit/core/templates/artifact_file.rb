class KuberKit::Core::Templates::ArtifactFile < KuberKit::Core::Templates::AbstractTemplate
  attr_reader :artifact_name, :file_path

  def initialize(template_name, artifact_name:, file_path:)
    super(template_name)
    @artifact_name = artifact_name
    @file_path = file_path
  end
end