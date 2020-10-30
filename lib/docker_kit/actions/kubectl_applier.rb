class DockerKit::Actions::KubectlApplier
  include DockerKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "ui"
  ]

  Contract String, Hash => Any
  def call(file_path, options)
    kubecfg_path = DockerKit.current_configuration.kubecfg_path
    ui.create_task("Applying file: #{file_path}") do |task|
      kubectl_commands.apply_file(local_shell, file_path, kubecfg_path: kubecfg_path)
      task.update_title("Applied file: #{file_path}")
    end
    nil
  end
end