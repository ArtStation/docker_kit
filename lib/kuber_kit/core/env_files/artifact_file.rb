class KuberKit::Core::EnvFiles::ArtifactFile < KuberKit::Core::EnvFiles::AbstractEnvFile
  attr_reader :artifact_name, :file_path

  def initialize(env_file_name, artifact_name:, file_path:)
    super(env_file_name)
    @artifact_name = artifact_name
    @file_path = file_path
  end

  def uniq_name
    [@artifact_name.to_s, @name.to_s].join("-")
  end
end