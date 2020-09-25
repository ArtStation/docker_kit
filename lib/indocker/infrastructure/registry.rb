class Indocker::Infrastructure::Registry
  include Indocker::Infrastructure::Concerns::Inspectable

  attr_reader :repository_name

  def initialize(repository_name)
    @repository_name = repository_name
  end

  def set_remote_url(remote_url)
    @remote_url = remote_url
    
    self
  end
  alias_method :setup, :set_remote_url

  def path
    repository_name.to_s
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