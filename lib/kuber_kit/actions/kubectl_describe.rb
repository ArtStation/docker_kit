class KuberKit::Actions::KubectlDescribe
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "ui"
  ]

  Contract Maybe[String], Hash => Any
  def call(resource_name, options)
    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    if !resource_name 
      resource_name  = get_resource_name
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

  def get_resource_name
    deployments     = kubectl_commands.get_resources(local_shell, "deployments", jsonpath: ".items[*].metadata.name")
    options  = deployments.split(" ").map{|d| "deploy/#{d}" }
    options  += ["ingresses", "pods"]
    option  = ui.prompt("Please select resource to describe", options)

    if option == "ingresses"
      ingresses = kubectl_commands.get_resources(local_shell, "ingresses", jsonpath: ".items[*].metadata.name")
      options   = ingresses.split(" ").map{|d| "ingresses/#{d}" }
      return ui.prompt("Please select ingress to describe", options)
    end

    if option == "pods"
      ingresses = kubectl_commands.get_resources(local_shell, "pods", jsonpath: ".items[*].metadata.name")
      options   = ingresses.split(" ").map{|d| "pods/#{d}" }
      return ui.prompt("Please select pod to describe", options)
    end
    
    option
  end
end