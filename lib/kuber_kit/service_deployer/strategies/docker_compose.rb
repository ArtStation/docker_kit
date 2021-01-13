class KuberKit::ServiceDeployer::Strategies::DockerCompose < KuberKit::ServiceDeployer::Strategies::Abstract
  include KuberKit::Import[
    "service_reader.reader",
    "shell.docker_compose_commands",
    "configs",
  ]

  STRATEGY_OPTIONS = [
    :service_name, 
    :command_name,
    :custom_args,
    :detached
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def deploy(shell, service)
    service_config = reader.read(shell, service)
    config_path    = "#{configs.service_config_dir}/#{service.name}.yml"
    shell.write(config_path, service_config)

    strategy_options = service.attribute(:deployer, default: {})
    unknown_options  = strategy_options.keys.map(&:to_sym) - STRATEGY_OPTIONS
    if unknown_options.any?
      raise KuberKit::Error, "Unknow options for deploy strategy: #{unknown_options}. Available options: #{STRATEGY_OPTIONS}"
    end

    service_name = strategy_options.fetch(:service_name, service.name.to_s)
    command_name = strategy_options.fetch(:command_name, "bash")
    custom_args = strategy_options.fetch(:custom_args, nil)

    docker_compose_commands.run(shell, config_path, 
      service:  service_name, 
      command:  command_name,
      args:     custom_args, 
      detached: !!strategy_options[:detached]
    )
  end
end