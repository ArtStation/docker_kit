class KuberKit::Core::EnvFiles::AbstractEnvFile
  include KuberKit::Extensions::Inspectable

  attr_reader :name

  def initialize(env_file_name)
    @name = env_file_name
  end
end