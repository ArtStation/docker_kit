class KuberKit::ServiceDeployer::Strategies::Kubernetes < KuberKit::ServiceDeployer::Strategies::Abstract
  include KuberKit::Import[
    "service_deployer.service_reader",
    "shell.kubectl_commands",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def restart(shell, service)
    service_config = service_reader.read(shell, service)
    config_path    = "#{configs.service_config_dir}/#{service.name}.yml"
    shell.write(config_path, service_config)

    kubecfg_path = KuberKit.current_configuration.kubecfg_path
    kubectl_commands.apply_file(shell, config_path, kubecfg_path: kubecfg_path)
    kubectl_commands.rolling_restart(shell, service.uri, kubecfg_path: kubecfg_path)
  end
end