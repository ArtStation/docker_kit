class Indocker::Core::Registries::Registry < Indocker::Core::Registries::AbstractRegistry
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