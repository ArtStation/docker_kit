class Indocker::Core::Configuration
  attr_reader :name, :artifacts, :registries, :env_files

  Contract KeywordArgs[
    name:            Symbol,
    artifacts:       Hash,
    registries:      Hash,
    env_files:       Hash,
  ] => Any
  def initialize(name:, artifacts:, registries:, env_files:)
    @name = name
    @artifacts  = artifacts
    @registries = registries
    @env_files  = env_files
  end
end