class DockerKit::Core::Registries::AbstractRegistry
  include DockerKit::Extensions::Inspectable

  attr_reader :name

  def initialize(registry_name)
    @name = registry_name
  end

  def path
    raise DockerKit::NotImplementedError, "must be implemented"
  end

  def remote_path
    raise DockerKit::NotImplementedError, "must be implemented"
  end

  def remote?
    raise DockerKit::NotImplementedError, "must be implemented"
  end

  def local?
    raise DockerKit::NotImplementedError, "must be implemented"
  end
end