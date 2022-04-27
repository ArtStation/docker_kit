class KuberKit::Actions::ShellLauncher
  include KuberKit::Import[
    "shell.local_shell",
    "shell.kubectl_commands",
    "ui",
  ]

  Contract nil => Any
  def call()
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    if kubeconfig_path.is_a?(KuberKit::Core::ArtifactPath)
      kubeconfig_path = artifact_path_resolver.call(kubeconfig_path)
    end

    deployer_namespace = KuberKit.current_configuration.deployer_namespace
    if deployer_namespace
      kubectl_commands.set_namespace(local_shell, deployer_namespace, kubeconfig_path: kubeconfig_path)
    end

    local_shell.replace!(env: ["KUBECONFIG=#{kubeconfig_path}"])

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end