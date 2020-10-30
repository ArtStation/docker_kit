class KuberKit::Core::Configuration
  attr_reader :name, :artifacts, :registries, :env_files, :templates, :kubeconfig_path, :deploy_strategy

  Contract KeywordArgs[
    name:            Symbol,
    artifacts:       Hash,
    registries:      Hash,
    env_files:       Hash,
    templates:       Hash,
    kubeconfig_path:    Maybe[String],
    deploy_strategy: Symbol
  ] => Any
  def initialize(name:, artifacts:, registries:, env_files:, templates:, kubeconfig_path:, deploy_strategy:)
    @name             = name
    @artifacts        = artifacts
    @registries       = registries
    @env_files        = env_files
    @templates        = templates
    @kubeconfig_path  = kubeconfig_path
    @deploy_strategy  = deploy_strategy
  end
end