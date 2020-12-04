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
    deploy_namespace = KuberKit.current_configuration.deploy_namespace

    deployment_resource_name  = service.attribute(:deployment_resource_name, default: service.uri)
    deployment_resource_type  = service.attribute(:deployment_resource_type, default: "job")

    deployment_delete_enabled = service.attribute(:deployment_delete_enabled, default: true)
    if deployment_delete_enabled
      delete_resource_if_exists(shell, deployment_resource_type, deployment_resource_name, kubeconfig_path: kubeconfig_path, namespace: deploy_namespace)
    end

    kubectl_commands.apply_file(shell, config_path, kubeconfig_path: kubeconfig_path, namespace: deploy_namespace)
  end

  private
    def delete_resource_if_exists(shell, resource_type, resource_name, kubeconfig_path:, namespace: )
      unless kubectl_commands.resource_exists?(shell, resource_type, resource_name, kubeconfig_path: kubeconfig_path, namespace: namespace)
        return false
      end
      kubectl_commands.delete_resource(shell, resource_type, resource_name, kubeconfig_path: kubeconfig_path, namespace: namespace)
    end
end