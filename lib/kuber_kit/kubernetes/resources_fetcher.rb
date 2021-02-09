class KuberKit::Kubernetes::ResourcesFetcher
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "ui"
  ]

  Contract String, KeywordArgs[
    include_ingresses: Optional[Bool],
    include_pods:      Optional[Bool]
  ] => Any
  def call(action_name, include_ingresses: false, include_pods: false)
    deployments = get_resources("deployments")
    options  = deployments.split(" ").map{|d| "deploy/#{d}" }
    options  << "ingresses" if include_ingresses
    options  << "pods" if include_pods
    option  = ui.prompt("Please select resource to #{action_name}", options)

    if option == "ingresses" && include_ingresses
      ingresses = get_resources("ingresses")
      options   = ingresses.split(" ").map{|d| "ingresses/#{d}" }
      return ui.prompt("Please select ingress to #{action_name}", options)
    end

    if option == "pods" && include_pods
      ingresses = get_resources("pods")
      options   = ingresses.split(" ").map{|d| "pods/#{d}" }
      return ui.prompt("Please select pod to #{action_name}", options)
    end
    
    option
  end

  def get_resources(type)
    kubectl_commands.get_resources(
      local_shell, type, 
      jsonpath: ".items[*].metadata.name", 
      namespace: KuberKit.current_configuration.deployer_namespace
    )
  end
end