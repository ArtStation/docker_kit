class Indocker::Core::ServiceDefinitionFactory
  def create(service_name)
    Indocker::Core::ServiceDefinition.new(service_name)
  end
end