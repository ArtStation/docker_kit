class Indocker::Core::EnvFiles::AbstractEnvFile
  include Indocker::Extensions::Inspectable

  attr_reader :env_file_name

  def initialize(env_file_name)
    @env_file_name = env_file_name
  end
end