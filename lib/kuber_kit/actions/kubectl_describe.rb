class KuberKit::Actions::KubectlDescribe
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "kubernetes.resource_selector",
    "ui"
  ]

  Contract Maybe[String], Hash => Any
  def call(resource_name, options)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    if !resource_name 
      resource_name  = resource_selector.call("describe", additional_resources: [
        KuberKit::Kubernetes::Resources::INGRESS, 
        KuberKit::Kubernetes::Resources::POD,
        KuberKit::Kubernetes::Resources::JOB,
        KuberKit::Kubernetes::Resources::CRONJOB
      ])
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