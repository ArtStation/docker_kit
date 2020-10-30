class KuberKit::Core::Registries::AbstractRegistry
  include KuberKit::Extensions::Inspectable

  attr_reader :name

  def initialize(registry_name)
    @name = registry_name
  end

  def path
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def remote_path
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def remote?
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def local?
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end