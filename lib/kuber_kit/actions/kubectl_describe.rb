class KuberKit::Actions::KubectlDescribe
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
      deployments     = kubectl_commands.get_resources(local_shell, "deployments", jsonpath: ".items[*].metadata.name")
      deploy_options  = deployments.split(" ").map{|d| "deploy/#{d}" }
      pod_name  = ui.prompt("Please select deployment to describe", deploy_options)
    end

    args = nil
    if options[:follow]
      args = "-f"
    end

    kubectl_commands.describe(
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