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
    :custom_args,
    :delete_if_exists,
    :volumes,
    :networks,
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def deploy(shell, service)
    strategy_options = service.attribute(:deployer, default: {})
    unknown_options  = strategy_options.keys.map(&:to_sym) - STRATEGY_OPTIONS
    if unknown_options.any?
      raise KuberKit::Error, "Unknow options for deploy strategy: #{unknown_options}. Available options: #{STRATEGY_OPTIONS}"
    end
    
    container_name = strategy_options.fetch(:container_name, service.uri)
    command_name   = strategy_options.fetch(:command_name, nil)
    custom_args    = strategy_options.fetch(:custom_args, nil)
    networks       = strategy_options.fetch(:networks, [])
    volumes        = strategy_options.fetch(:volumes, [])
    hostname       = strategy_options.fetch(:hostname, container_name)

    image_name = strategy_options.fetch(:image_name, nil)
    if image_name.nil?
      raise KuberKit::Error, "image_name is mandatory attribute for this deploy strategy"
    end
    image = image_store.get_image(image_name.to_sym)

    delete_enabled = strategy_options.fetch(:delete_if_exists, false)
    if delete_enabled && docker_commands.container_exists?(shell, container_name)
      docker_commands.delete_container(shell, container_name)
    end

    custom_args = Array(custom_args)
    if container_name
      custom_args << "--name #{container_name}"
    end
    if hostname
      custom_args << "--hostname #{hostname}"
    end
    networks.each do |network|
      docker_commands.create_network(shell, network)
      custom_args << "--network #{network}"
    end
    volumes.each do |volume|
      volume_name, _ = volume.split(":")
      docker_commands.create_volume(shell, volume_name) unless volume_name.start_with?("/")
      custom_args << "--volume #{volume}"
    end

    docker_commands.run(
      shell, image.remote_registry_url, 
      command:      command_name,
      args:         custom_args, 
      detached:     !!strategy_options[:detached],
      interactive:  !strategy_options[:detached]
    )
  end
end