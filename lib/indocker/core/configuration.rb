class Indocker::Core::Configuration
  attr_reader :name, :artifacts, :registries, :env_files, :templates

  Contract KeywordArgs[
    name:            Symbol,
    artifacts:       Hash,
    registries:      Hash,
    env_files:       Hash,
    templates:       Hash
  ] => Any
  def initialize(name:, artifacts:, registries:, env_files:, templates:)
    @name = name
    @artifacts  = artifacts
    @registries = registries
    @env_files  = env_files
    @templates  = templates
  end
end