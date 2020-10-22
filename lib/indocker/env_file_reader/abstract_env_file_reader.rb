class Indocker::EnvFileReader::AbstractEnvFileReader
  def read(shell, env_file)
    raise Indocker::NotImplementedError, "must be implemented"
  end
end