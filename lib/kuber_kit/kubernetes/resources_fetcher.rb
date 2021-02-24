class KuberKit::Kubernetes::ResourcesFetcher
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
  ]

  Contract String => ArrayOf[String]
  def call(resource_type)
    current_configuration  = KuberKit.current_configuration
    
    result = kubectl_commands.get_resources(
      local_shell, resource_type, 
      jsonpath:         ".items[*].metadata.name", 
      kubeconfig_path:  current_configuration.kubeconfig_path, 
      namespace:        current_configuration.deployer_namespace
    )

    result.split(" ")
  end
end