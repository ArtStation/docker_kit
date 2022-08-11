class KuberKit::Kubernetes::ResourceSelector
  include KuberKit::Import[
    "kubernetes.resources_fetcher",
    "shell.local_shell",
    "ui"
  ]

  Contract String, KeywordArgs[
    immediate_resource:   Optional[String],
    additional_resources: Optional[ArrayOf[String]]
  ] => Any
  def call(action_name, immediate_resource: "deploy", additional_resources: [])
    deployments = resources_fetcher.call(immediate_resource)
    options  = deployments.map{|d| "#{immediate_resource}/#{d}" }
    options  += additional_resources
    option  = ui.prompt("Please select resource to #{action_name}", options)

    additional_resources.each do |resource_name|
      if option == resource_name && additional_resources.include?(resource_name)
        ingresses = resources_fetcher.call(resource_name)
        options   = ingresses.map{|d| "#{resource_name}/#{d}" }
        return ui.prompt("Please select #{resource_name} to #{action_name}", options)
      end
    end
    
    option
  end
end