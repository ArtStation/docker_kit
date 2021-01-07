class KuberKit::Actions::KubectlAttacher
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "ui"
  ]

  Contract Maybe[String], Hash => Any
  def call(pod_name, options)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    if !pod_name 
      resources = kubectl_commands.get_resources(local_shell, "deployments", jsonpath: ".items[*].metadata.name")
      options   = resources.split(" ").map{|d| "deploy/#{d}" }
      pod_name  = ui.prompt("Please select deployment to attach", options)
    end

    kubectl_commands.exec(
      local_shell, pod_name, "bash", args: "-it", 
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