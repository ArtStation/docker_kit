class Indocker::Core::ConfigurationDefinition
  ResourceAlreadyAdded = Class.new(Indocker::Error)

  attr_reader :configuration_name

  Contract Or[Symbol, String] => Any
  def initialize(configuration_name)
    @configuration_name = configuration_name.to_sym
    @artifacts  = {}
    @registries = {}
  end

  def to_attrs
    OpenStruct.new(
      name:             @configuration_name,
      artifacts:     @artifacts,
      registries:       @registries
    )
  end

  def use_artifact(artifact_name, as:)
    if @artifacts.has_key?(as)
      raise ResourceAlreadyAdded.new("alias name :#{as} is already used by artifact: #{@artifacts[as].inspect}")
    end
    @artifacts[as] = artifact_name

    self
  end

  def use_registry(artifact_name, as:)
    if @registries.has_key?(as)
      raise ResourceAlreadyAdded.new("alias name :#{as} is already used by registry: #{@registries[as].inspect}")
    end
    @registries[as] = artifact_name

    self
  end
end