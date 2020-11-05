class KuberKit::Core::EnvFiles::EnvFileStore
  def add(env_file)
    store.add(env_file.name, env_file)
  end

  def get(env_file_name)
    env_file = get_from_configuration(env_file_name) || 
               get_global(env_file_name)

    env_file
  end

  def get_global(env_file_name)
    store.get(env_file_name)
  end

  def get_from_configuration(env_file_name)
    env_files = KuberKit.current_configuration.env_files
    env_files[env_file_name]
  end

  def reset!
    store.reset!
  end

  private
    def store
      @@store ||= KuberKit::Core::Store.new(KuberKit::Core::EnvFiles::AbstractEnvFile)
    end
end