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

    kubeconfig_path  = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace

    kubectl_commands.apply_file(shell, config_path, kubeconfig_path: kubeconfig_path, namespace: deployer_namespace)

    deployer_restart_enabled = service.attribute(:deployer_restart_enabled, default: true)
    deployer_restart_name    = service.attribute(:deployer_restart_name, default: service.uri)
    if deployer_restart_enabled
      kubectl_commands.rolling_restart(shell, deployer_restart_name, kubeconfig_path: kubeconfig_path, namespace: deployer_namespace)
    end
  end
end