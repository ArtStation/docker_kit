require 'json'

class DockerKit::Actions::EnvFileReader
  include DockerKit::Import[
    "core.env_file_store",
    "env_file_reader.reader",
    "shell.local_shell",
    "ui"
  ]

  Contract Symbol, Hash => Any
  def call(env_file_name, options)
    env_file = env_file_store.get(env_file_name)
    result = reader.read(local_shell, env_file)
    ui.print_info(env_file_name.to_s, JSON.pretty_generate(result))
  end
end