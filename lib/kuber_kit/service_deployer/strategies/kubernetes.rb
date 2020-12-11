class KuberKit::ServiceDeployer::Strategies::Kubernetes < KuberKit::ServiceDeployer::Strategies::Abstract
  include KuberKit::Import[
    "service_reader.reader",
    "shell.kubectl_commands",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def deploy(shell, service)
    service_config = reader.read(shell, service)
    config_path    = "#{configs.service_config_dir}/#{service.name}.yml"
    shell.write(config_path, service_config)

    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    namespace       = KuberKit.current_configuration.deployer_namespace
    
    resource_type = service.attribute(:deployer_resource_type, default: "deployment")
    resource_name = service.attribute(:deployer_resource_name, default: service.uri)
    
    resource_exists = kubectl_commands.resource_exists?(
      shell, resource_type, resource_name, kubeconfig_path: kubeconfig_path, namespace: namespace
    )

    delete_enabled = service.attribute(:deployer_delete_if_exists, default: false)
    if delete_enabled && resource_exists
      kubectl_commands.delete_resource(shell, resource_type, resource_name, kubeconfig_path: kubeconfig_path, namespace: namespace)
    end

    kubectl_commands.apply_file(shell, config_path, kubeconfig_path: kubeconfig_path, namespace: namespace)

    restart_enabled = service.attribute(:deployer_restart_if_exists, default: true)
    if restart_enabled && resource_exists
      kubectl_commands.rolling_restart(
        shell, resource_type, resource_name, 
        kubeconfig_path: kubeconfig_path, namespace: namespace
      )
    end
  end
end