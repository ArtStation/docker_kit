class KuberKit::ImageCompiler::BuildServerPoolFactory
  include KuberKit::Import[
    "shell.local_shell",
  ]

  def create(ssh_shell_class:)
    KuberKit::ImageCompiler::BuildServerPool.new(
      local_shell:      local_shell,
      build_servers:    KuberKit.current_configuration.build_servers,
      ssh_shell_class:  ssh_shell_class,
    )
  end
end