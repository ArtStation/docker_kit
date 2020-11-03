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
    kubectl_commands.apply_file(shell, config_path, kubeconfig_path: kubeconfig_path)

    deployment_restart_enabled = service.attribute(:deployment_restart_enabled, default: true)
    deployment_restart_name    = service.attribute(:deployment_restart_name, default: service.uri)
    if deployment_restart_enabled
      kubectl_commands.rolling_restart(shell, deployment_restart_name, kubeconfig_path: kubeconfig_path)
    end
  end
end