class KuberKit::EnvFileReader::Strategies::EnvGroup < KuberKit::EnvFileReader::Strategies::Abstract
  include KuberKit::Import[
    "env_file_reader.strategies.artifact_file",
    "core.env_file_store",
  ]

  def read(shell, env_group)
    content = {}
    env_group.env_files.each do |env_file_name|
      env_file = env_file_store.get(env_file_name)

      if env_file.is_a?(KuberKit::Core::EnvFiles::EnvGroup)
        raise "EnvGroup inside another EnvGroup is not supported"
      end

      result   = artifact_file.read(shell, env_file)
      content  = content.merge(result)
    end
    content
  end
end