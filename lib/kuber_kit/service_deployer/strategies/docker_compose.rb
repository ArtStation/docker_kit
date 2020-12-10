class KuberKit::ServiceDeployer::Strategies::DockerCompose < KuberKit::ServiceDeployer::Strategies::Abstract
  include KuberKit::Import[
    "service_reader.reader",
    "shell.docker_compose_commands",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def deploy(shell, service)
    service_config = reader.read(shell, service)
    config_path    = "#{configs.service_config_dir}/#{service.name}.yml"
    shell.write(config_path, service_config)

    deployer_service_name = service.attribute(:deployer_service_name, default: service.name.to_s)
    deployer_command_name = service.attribute(:deployer_command_name, default: "bash")
    deployer_interactive  = service.attribute(:deployer_interactive, default: false)

    docker_compose_commands.run(shell, config_path, 
      service:      deployer_service_name, 
      command:      deployer_command_name,
      interactive:  deployer_interactive
    )
  end
end