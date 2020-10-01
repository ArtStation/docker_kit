class Indocker::Core::InfraStore
  NotFoundError = Class.new(StandardError)
  AlreadyAddedError = Class.new(StandardError)

  def add_registry(registry)
    @@registries ||= {}

    if !registry.is_a?(Indocker::Core::Registry)
      raise ArgumentError.new("should be an instance of Indocker::Core::Registry, got: #{registry.inspect}")
    end

    unless @@registries[registry.repository_name].nil?
      raise AlreadyAddedError, "registry #{registry.repository_name} was already added"
    end

    @@registries[registry.repository_name] = registry
  end

  def get_registry(repository_name)
    @@registries ||= {}

    if @@registries[repository_name].nil?
      raise NotFoundError, "registry #{repository_name} not found"
    end

    @@registries[repository_name]
  end

  def default_registry
    @default_registry ||= Indocker::Core::Registry.new(:default)
  end

  def reset!
    @@registries = {}
  end
end