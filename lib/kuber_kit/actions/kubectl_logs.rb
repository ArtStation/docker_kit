class KuberKit::Actions::KubectlLogs
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "kubernetes.resources_fetcher",
    "ui"
  ]

  Contract Maybe[String], Hash => Any
  def call(pod_name, options)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    if !pod_name 
      pod_name = resources_fetcher.call("attach")
    end

    args = nil
    if options[:follow]
      args = "-f"
    end

    kubectl_commands.logs(
      local_shell, pod_name,
      args: args,
      kubeconfig_path: kubeconfig_path, 
      namespace: deployer_namespace
    )

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end