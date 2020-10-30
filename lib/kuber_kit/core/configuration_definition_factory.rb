class KuberKit::Core::ConfigurationDefinitionFactory
  def create(configuration_name)
    KuberKit::Core::ConfigurationDefinition.new(configuration_name)
  end
end