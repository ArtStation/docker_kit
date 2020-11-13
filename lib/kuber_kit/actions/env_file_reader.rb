require 'json'

class KuberKit::Actions::EnvFileReader
  include KuberKit::Import[
    "shell.local_shell",
    "ui",
    env_file_reader: "env_file_reader.action_handler",
  ]

  Contract Symbol, Hash => Any
  def call(env_file_name, options)
    result = env_file_reader.call(local_shell, env_file_name)
    ui.print_info(env_file_name.to_s, JSON.pretty_generate(result))

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    false
  end
end