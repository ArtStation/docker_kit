class Indocker::Core::Registry
  include Indocker::Extensions::Inspectable

  attr_reader :registry_name

  def initialize(registry_name)
    @registry_name = registry_name
  end

  def set_remote_url(remote_url)
    @remote_url = remote_url
    
    self
  end
  alias_method :setup, :set_remote_url

  def path
    registry_name.to_s
  end

  def remote_path
    [@remote_url, path].compact.join("/")
  end

  def remote?
    !local?
  end

  def local?
    @remote_url.nil?
  end
end