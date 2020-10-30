class DockerKit::Core::ServiceDefinitionFactory
  def create(service_name)
    DockerKit::Core::ServiceDefinition.new(service_name)
  end
end