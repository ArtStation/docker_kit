class KuberKit::ServiceDeployer::Deployer
  include KuberKit::Import[
    "core.service_store",
    "service_deployer.service_reader",
    "shell.kubectl_commands",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def deploy(shell, service_name)
    service = service_store.get_service(service_name)
    kubecfg_path = KuberKit.current_configuration.kubecfg_path

    result = service_reader.read(shell, service)
    file_path = "#{configs.service_config_dir}/#{service.name}.yml"
    shell.write(file_path, result)

    kubectl_commands.apply_file(shell, file_path, kubecfg_path: kubecfg_path)
  end
end