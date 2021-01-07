class KuberKit::Actions::KubectlConsole
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "ui"
  ]

  Contract String, Hash => Any
  def call(pod_name, options)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    kubectl_commands.exec(
      local_shell, pod_name, "bin/console", args: "-it", 
      kubeconfig_path: kubeconfig_path, 
      interactive: true,
      namespace: deployer_namespace
    )

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end