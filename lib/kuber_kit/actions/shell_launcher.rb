class KuberKit::Actions::ShellLauncher
  include KuberKit::Import[
    "shell.local_shell",
    "shell_launcher.action_handler",
    "ui",
  ]

  Contract nil => Any
  def call()
    action_handler.call(local_shell)

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end