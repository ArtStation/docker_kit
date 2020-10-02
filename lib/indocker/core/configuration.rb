class Indocker::Core::Configuration
  attr_reader :name, :repositories, :registries

  Contract KeywordArgs[
    name:               Symbol,
    repositories:       Hash,
    registries:         Hash,
  ] => Any
  def initialize(name:, repositories:, registries:)
    @name = name
    @repositories = repositories
    @registries = registries
  end
end