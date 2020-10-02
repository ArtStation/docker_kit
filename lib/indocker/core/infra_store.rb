class Indocker::Core::InfraStore
  NotFoundError = Class.new(Indocker::Error)
  AlreadyAddedError = Class.new(Indocker::Error)

  include Indocker::Import[
    "shell.local_shell"
  ]

  def add_registry(registry)
    @@registries ||= {}

    if !registry.is_a?(Indocker::Core::Registry)
      raise ArgumentError.new("should be an instance of Indocker::Core::Registry, got: #{registry.inspect}")
    end

    unless @@registries[registry.registry_name].nil?
      raise AlreadyAddedError, "registry #{registry.registry_name} was already added"
    end

    @@registries[registry.registry_name] = registry
  end

  def get_registry(registry_name)
    registry = get_configuration_registry(registry_name) || 
               get_global_registry(registry_name)

    registry
  end

  def get_global_registry(registry_name)
    @@registries ||= {}
    registry = @@registries[registry_name]

    if registry.nil?
      raise NotFoundError, "registry #{registry_name} not found"
    end
    
    registry
  end

  def get_configuration_registry(registry_name)
    registries = Indocker.current_configuration.registries
    registries[registry_name]
  end

  def default_registry
    @default_registry ||= Indocker::Core::Registry.new(:default)
  end

  def load_infra_items(infra_path)
    files = local_shell.recursive_list_files(infra_path).each do |path|
      load_infra_item(path)
    end
  end

  def load_infra_item(file_path)
    require(file_path)
  end

  def reset!
    @@registries = {}
  end
end