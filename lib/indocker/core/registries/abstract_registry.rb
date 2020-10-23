class Indocker::Core::Registries::AbstractRegistry
  include Indocker::Extensions::Inspectable

  attr_reader :name

  def initialize(registry_name)
    @name = registry_name
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