class KuberKit::Actions::KubectlAttacher
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "ui"
  ]

  Contract String, Hash => Any
  def call(pod_name, options)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    deploy_namespace = KuberKit.current_configuration.deploy_namespace

    kubectl_commands.exec(
      local_shell, pod_name, "bash", args: "-it", 
      kubeconfig_path: kubeconfig_path, 
      interactive: true,
      namespace: deploy_namespace
    )

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end