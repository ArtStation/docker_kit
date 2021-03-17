class KuberKit::Actions::KubectlGet
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

    resources = kubectl_commands.get_resources(
      local_shell, "pod",
      kubeconfig_path: kubeconfig_path, 
      namespace: deployer_namespace
    )

    matching_resources = resources.select{|r| r.include?(resource_name) }

    ui.print_info("Pods", matching_resources.join("\n"))

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end