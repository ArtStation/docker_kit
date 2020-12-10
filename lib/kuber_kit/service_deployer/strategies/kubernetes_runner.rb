class KuberKit::ServiceDeployer::Strategies::KubernetesRunner < KuberKit::ServiceDeployer::Strategies::Abstract
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

    kubeconfig_path  = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    deployer_resource_name  = service.attribute(:deployer_resource_name, default: service.uri)
    deployer_resource_type  = service.attribute(:deployer_resource_type, default: "job")

    deployer_delete_enabled = service.attribute(:deployer_delete_enabled, default: true)
    if deployer_delete_enabled
      delete_resource_if_exists(shell, deployer_resource_type, deployer_resource_name, kubeconfig_path: kubeconfig_path, namespace: deployer_namespace)
    end

    kubectl_commands.apply_file(shell, config_path, kubeconfig_path: kubeconfig_path, namespace: deployer_namespace)
  end

  private
    def delete_resource_if_exists(shell, resource_type, resource_name, kubeconfig_path:, namespace: )
      unless kubectl_commands.resource_exists?(shell, resource_type, resource_name, kubeconfig_path: kubeconfig_path, namespace: namespace)
        return false
      end
      kubectl_commands.delete_resource(shell, resource_type, resource_name, kubeconfig_path: kubeconfig_path, namespace: namespace)
    end
end