class KuberKit::ShellLauncher::ActionHandler
  include KuberKit::Import[
    "shell_launcher.launcher",
  ]

  Contract KuberKit::Shell::AbstractShell => Any
  def call(shell)
    strategy_name = KuberKit.current_configuration.shell_launcher_strategy

    launcher.call(shell, strategy_name)
  end
end