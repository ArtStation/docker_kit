class KuberKit::Core::BuildServers::AbstractBuildServer
  include KuberKit::Extensions::Inspectable

  attr_reader :name

  def initialize(build_server_name)
    @name = build_server_name
  end

  def host
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def user
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def port
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end