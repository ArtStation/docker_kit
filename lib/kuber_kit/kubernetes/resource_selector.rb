class KuberKit::Kubernetes::ResourceSelector
  include KuberKit::Import[
    "kubernetes.resources_fetcher",
    "shell.local_shell",
    "ui"
  ]

  Contract String, KeywordArgs[
    include_ingresses: Optional[Bool],
    include_pods:      Optional[Bool]
  ] => Any
  def call(action_name, include_ingresses: false, include_pods: false)
    deployments = resources_fetcher.call("deployments")
    options  = deployments.map{|d| "deploy/#{d}" }
    options  << "ingresses" if include_ingresses
    options  << "pods" if include_pods
    option  = ui.prompt("Please select resource to #{action_name}", options)

    if option == "ingresses" && include_ingresses
      ingresses = resources_fetcher.call("ingresses")
      options   = ingresses.map{|d| "ingresses/#{d}" }
      return ui.prompt("Please select ingress to #{action_name}", options)
    end

    if option == "pods" && include_pods
      ingresses = resources_fetcher.call("pods")
      options   = ingresses.map{|d| "pods/#{d}" }
      return ui.prompt("Please select pod to #{action_name}", options)
    end
    
    option
  end
end