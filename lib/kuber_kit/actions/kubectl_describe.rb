class KuberKit::Actions::KubectlDescribe
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "kubernetes.resources_fetcher",
    "ui"
  ]

  Contract Maybe[String], Hash => Any
  def call(resource_name, options)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    if !resource_name 
      resource_name  = resources_fetcher.call("describe", include_ingresses: true, include_pods: true)
    end

    args = nil
    if options[:follow]
      args = "-f"
    end

    kubectl_commands.describe(
      local_shell, resource_name,
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