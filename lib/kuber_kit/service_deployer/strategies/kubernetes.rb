class KuberKit::ServiceDeployer::Strategies::Kubernetes < KuberKit::ServiceDeployer::Strategies::Abstract
  include KuberKit::Import[
    "service_reader.reader",
    "shell.kubectl_commands",
    "configs",
  ]

  STRATEGY_OPTIONS = [
    :resource_type,
    :resource_name,
    :delete_if_exists,
    :restart_if_exists
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def deploy(shell, service)
    service_config = reader.read(shell, service)
    config_path    = "#{configs.service_config_dir}/#{service.name}.yml"
    shell.write(config_path, service_config)

    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    namespace       = KuberKit.current_configuration.deployer_namespace

    strategy_options = service.attribute(:deployer, default: {})
    unknown_options  = strategy_options.keys.map(&:to_sym) - STRATEGY_OPTIONS
    if unknown_options.any?
      raise KuberKit::Error, "Unknow options for deploy strategy: #{unknown_options}. Available options: #{STRATEGY_OPTIONS}"
    end
    
    resource_type = strategy_options.fetch(:resource_type, "deployment")
    resource_name = strategy_options.fetch(:resource_name, service.uri)
    
    resource_exists = kubectl_commands.resource_exists?(
      shell, resource_type, resource_name, kubeconfig_path: kubeconfig_path, namespace: namespace
    )

    delete_enabled = strategy_options.fetch(:delete_if_exists, false)
    if delete_enabled && resource_exists
      kubectl_commands.delete_resource(shell, resource_type, resource_name, kubeconfig_path: kubeconfig_path, namespace: namespace)
    end

    apply_result = kubectl_commands.apply_file(shell, config_path, kubeconfig_path: kubeconfig_path, namespace: namespace)

    restart_enabled = strategy_options.fetch(:restart_if_exists, true)
    if restart_enabled && resource_exists
      kubectl_commands.rolling_restart(
        shell, resource_type, resource_name, 
        kubeconfig_path: kubeconfig_path, namespace: namespace
      )
    end
    
    apply_result
  end
end