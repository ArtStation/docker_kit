class Indocker::Core::EnvFiles::ArtifactFile < Indocker::Core::EnvFiles::AbstractEnvFile
  def initialize(env_file_name, file_path)
    super(env_file_name)
    @file_path = file_path
  end
end