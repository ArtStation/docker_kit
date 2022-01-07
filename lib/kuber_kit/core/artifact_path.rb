class KuberKit::Core::ArtifactPath
  attr_reader :artifact_name, :file_path

  def initialize(artifact_name:, file_path:)
    @artifact_name = artifact_name
    @file_path     = file_path
  end
end