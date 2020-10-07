class Indocker::Core::Registries::AbstractRegistry
  include Indocker::Extensions::Inspectable

  attr_reader :registry_name

  def initialize(registry_name)
    @registry_name = registry_name
  end

  def path
    raise Indocker::NotImplementedError, "must be implemented"
  end

  def remote_path
    raise Indocker::NotImplementedError, "must be implemented"
  end

  def remote?
    raise Indocker::NotImplementedError, "must be implemented"
  end

  def local?
    raise Indocker::NotImplementedError, "must be implemented"
  end
end