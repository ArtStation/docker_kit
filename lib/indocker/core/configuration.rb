class Indocker::Core::Configuration
  attr_reader :name, :artifacts, :registries

  Contract KeywordArgs[
    name:            Symbol,
    artifacts:       Hash,
    registries:      Hash,
  ] => Any
  def initialize(name:, artifacts:, registries:)
    @name = name
    @artifacts  = artifacts
    @registries = registries
  end
end