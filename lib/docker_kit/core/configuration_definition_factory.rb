class DockerKit::Core::ConfigurationDefinitionFactory
  def create(configuration_name)
    DockerKit::Core::ConfigurationDefinition.new(configuration_name)
  end
end