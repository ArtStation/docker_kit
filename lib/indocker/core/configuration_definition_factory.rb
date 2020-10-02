class Indocker::Core::ConfigurationDefinitionFactory
  def create(configuration_name)
    Indocker::Core::ConfigurationDefinition.new(configuration_name)
  end
end