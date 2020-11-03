class KuberKit::EnvFileReader::ActionHandler
  include KuberKit::Import[
    "env_file_reader.reader",
    "core.env_file_store",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def call(shell, env_file_name)
    env_file = env_file_store.get(env_file_name)
    reader.read(shell, env_file)
  end
end