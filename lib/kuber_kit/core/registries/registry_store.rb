class KuberKit::Core::Registries::RegistryStore
  def add(registry)
    store.add(registry.name, registry)
  end

  Contract Symbol => Maybe[KuberKit::Core::Registries::AbstractRegistry]
  def get(registry_name)
    registry = get_from_configuration(registry_name) || 
               get_global(registry_name)

    registry
  end

  Contract Symbol => Maybe[KuberKit::Core::Registries::AbstractRegistry]
  def get_global(registry_name)
    store.get(registry_name)
  end

  Contract Symbol => Maybe[KuberKit::Core::Registries::AbstractRegistry]
  def get_from_configuration(registry_name)
    registries = KuberKit.current_configuration.registries
    registries[registry_name]
  end

  def default_registry
    @default_registry ||= KuberKit::Core::Registries::Registry.new(:default)
  end

  def reset!
    store.reset!
  end

  private
    def store
      @@store ||= KuberKit::Core::Store.new(KuberKit::Core::Registries::AbstractRegistry)
    end
end