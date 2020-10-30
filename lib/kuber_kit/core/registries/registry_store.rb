class KuberKit::Core::Registries::RegistryStore
  NotFoundError = Class.new(KuberKit::NotFoundError)
  AlreadyAddedError = Class.new(KuberKit::Error)

  def add(registry)
    @@registries ||= {}

    if !registry.is_a?(KuberKit::Core::Registries::AbstractRegistry)
      raise ArgumentError.new("should be an instance of KuberKit::Core::Registries::AbstractRegistry, got: #{registry.inspect}")
    end

    unless @@registries[registry.name].nil?
      raise AlreadyAddedError, "registry #{registry.name} was already added"
    end

    @@registries[registry.name] = registry
  end

  def get(registry_name)
    registry = get_from_configuration(registry_name) || 
               get_global(registry_name)

    registry
  end

  def get_global(registry_name)
    @@registries ||= {}
    registry = @@registries[registry_name]

    if registry.nil?
      raise NotFoundError, "registry '#{registry_name}' not found"
    end
    
    registry
  end

  def get_from_configuration(registry_name)
    registries = KuberKit.current_configuration.registries
    registries[registry_name]
  end

  def default_registry
    @default_registry ||= KuberKit::Core::Registries::Registry.new(:default)
  end

  def reset!
    @@registries = {}
  end
end