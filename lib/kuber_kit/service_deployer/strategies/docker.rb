class KuberKit::ServiceDeployer::Strategies::Docker < KuberKit::ServiceDeployer::Strategies::Abstract
  include KuberKit::Import[
    "shell.docker_commands",
    "core.image_store",
    "configs",
  ]

  STRATEGY_OPTIONS = [
    :container_name,
    :image_name,
    :detached,
    :command_name,
    :command_args,
    :delete_if_exists
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def deploy(shell, service)
    strategy_options = service.attribute(:deployer, default: {})
    unknown_options  = strategy_options.keys.map(&:to_sym) - STRATEGY_OPTIONS
    if unknown_options.any?
      raise KuberKit::Error, "Unknow options for deploy strategy: #{unknown_options}. Available options: #{STRATEGY_OPTIONS}"
    end
    
    container_name = strategy_options.fetch(:container_name, service.uri)
    command_name   = strategy_options.fetch(:command_name, "bash")
    command_args   = strategy_options.fetch(:command_args, nil)

    image_name = strategy_options.fetch(:image_name, nil)
    if image_name.nil?
      raise KuberKit::Error, "image_name is mandatory attribute for this deploy strategy"
    end
    image = image_store.get_image(image_name.to_sym)

    delete_enabled = strategy_options.fetch(:delete_if_exists, false)
    if delete_enabled && docker_commands.container_exists?(shell, container_name)
      docker_commands.delete_container(shell, container_name)
    end

    docker_commands.run(
      shell, image.remote_registry_url, 
      command:    command_name,
      args:       command_args, 
      detached:   !!strategy_options[:detached]
    )
  end
end