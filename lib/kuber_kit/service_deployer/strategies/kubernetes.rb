class KuberKit::ServiceDeployer::Strategies::Kubernetes < KuberKit::ServiceDeployer::Strategies::Abstract
  include KuberKit::Import[
    "service_deployer.service_reader",
    "shell.kubectl_commands",
    "core.service_store",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def deploy(shell, service_name)
    service = service_store.get_service(service_name)

    result = service_reader.read(shell, service)
    file_path = "#{configs.service_config_dir}/#{service.name}.yml"
    shell.write(file_path, result)

    kubecfg_path = KuberKit.current_configuration.kubecfg_path
    kubectl_commands.apply_file(shell, file_path, kubecfg_path: kubecfg_path)
    kubectl_commands.rolling_restart(shell, service.uri, kubecfg_path: kubecfg_path)
  end
end