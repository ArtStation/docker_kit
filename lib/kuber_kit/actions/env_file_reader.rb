require 'json'

class KuberKit::Actions::EnvFileReader
  include KuberKit::Import[
    "env_file_reader.action_handler",
    "shell.local_shell",
    "ui"
  ]

  Contract Symbol, Hash => Any
  def call(env_file_name, options)
    result = action_handler.call(local_shell, env_file_name)
    ui.print_info(env_file_name.to_s, JSON.pretty_generate(result))
  end
end