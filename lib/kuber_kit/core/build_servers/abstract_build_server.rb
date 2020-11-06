class KuberKit::Core::BuildServers::AbstractBuildServer
  include KuberKit::Extensions::Inspectable

  attr_reader :name

  def initialize(build_server_name)
    @name = build_server_name
  end
end