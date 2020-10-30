class DockerKit::Core::EnvFiles::AbstractEnvFile
  include DockerKit::Extensions::Inspectable

  attr_reader :name

  def initialize(env_file_name)
    @name = env_file_name
  end
end