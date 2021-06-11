class KuberKit::Core::EnvFiles::EnvGroup < KuberKit::Core::EnvFiles::AbstractEnvFile
  attr_reader :env_files

  def initialize(env_group_name, env_files:)
    super(env_group_name)
    @env_files = env_files
  end

  def uniq_name
    "env-group-#{@name.to_s}"
  end
end