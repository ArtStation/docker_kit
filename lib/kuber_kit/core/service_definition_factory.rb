class KuberKit::Core::ServiceDefinitionFactory
  def create(service_name)
    KuberKit::Core::ServiceDefinition.new(service_name)
  end
end