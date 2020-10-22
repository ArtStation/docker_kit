class Indocker::Core::EnvFiles::ArtifactFile < Indocker::Core::EnvFiles::AbstractEnvFile
  attr_reader :artifact_name, :file_path

  def initialize(env_file_name, artifact_name:, file_path:)
    super(env_file_name)
    @artifact_name = artifact_name
    @file_path = file_path
  end
end