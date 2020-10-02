class Indocker::Core::ConfigurationDefinition
  ResourceAlreadyAdded = Class.new(StandardError)

  attr_reader :configuration_name

  Contract Or[Symbol, String] => Any
  def initialize(configuration_name)
    @configuration_name = configuration_name.to_sym
    @repositories = {}
    @registries   = {}
  end

  def to_attrs
    OpenStruct.new(
      name:             @configuration_name,
      repositories:     @repositories,
      registries:       @registries
    )
  end

  def use_repository(repo_name, as:)
    if @repositories.has_key?(as)
      raise ResourceAlreadyAdded.new("alias name :#{as} is already used by repository: #{@repositories[as].inspect}")
    end
    @repositories[as] = repo_name

    self
  end

  def use_registry(repo_name, as:)
    if @registries.has_key?(as)
      raise ResourceAlreadyAdded.new("alias name :#{as} is already used by registry: #{@registries[as].inspect}")
    end
    @registries[as] = repo_name

    self
  end
end