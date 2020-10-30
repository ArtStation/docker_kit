class KuberKit::Core::Configuration
  attr_reader :name, :artifacts, :registries, :env_files, :templates, :kubecfg_path, :deploy_strategy

  Contract KeywordArgs[
    name:            Symbol,
    artifacts:       Hash,
    registries:      Hash,
    env_files:       Hash,
    templates:       Hash,
    kubecfg_path:    Maybe[String],
    deploy_strategy: Symbol
  ] => Any
  def initialize(name:, artifacts:, registries:, env_files:, templates:, kubecfg_path:, deploy_strategy:)
    @name           = name
    @artifacts      = artifacts
    @registries     = registries
    @env_files      = env_files
    @templates      = templates
    @kubecfg_path   = kubecfg_path
    @deploy_strategy = deploy_strategy
  end
end