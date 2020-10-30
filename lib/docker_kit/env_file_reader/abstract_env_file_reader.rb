class DockerKit::EnvFileReader::AbstractEnvFileReader
  def read(shell, env_file)
    raise DockerKit::NotImplementedError, "must be implemented"
  end
end