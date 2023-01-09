class KuberKit::Actions::KubectlGet
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "kubernetes.resource_selector",
    "ui"
  ]

  Contract Maybe[String], Hash => Array
  def call(resource_name, options)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    resources = kubectl_commands.get_resources(
      local_shell, "pod",
      kubeconfig_path: kubeconfig_path, 
      namespace: deployer_namespace
    )
    
    if resource_name
      resources = resources.select{|r| r.include?(resource_name) }
    end

    ui.print_info("Pods", resources.join("\n"))

    resources
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    []
  end
end