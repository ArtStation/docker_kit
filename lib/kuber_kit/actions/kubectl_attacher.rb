class KuberKit::Actions::KubectlAttacher
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "kubernetes.resource_selector",
    "ui"
  ]

  Contract Maybe[String], Hash => Any
  def call(resource_name, options)
    kubeconfig_path    = KuberKit.current_configuration.kubeconfig_path
    kubectl_entrypoint = KuberKit.current_configuration.kubectl_entrypoint
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    if !resource_name 
      resource_name  = resource_selector.call("attach", additional_resources: [
        KuberKit::Kubernetes::Resources::POD,
        KuberKit::Kubernetes::Resources::JOB
      ])
    end

    kubectl_commands.exec(
      local_shell, resource_name, "bash", args: "-it", 
      kubeconfig_path: kubeconfig_path, 
      interactive:  true,
      namespace:    deployer_namespace,
      entrypoint:   kubectl_entrypoint
    )

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end