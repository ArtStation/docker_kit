class KuberKit::Core::Configuration
  attr_reader :name, :artifacts, :registries, :env_files, :templates, :kubeconfig_path, 
              :deploy_strategy, :services_attributes, :build_servers

  Contract KeywordArgs[
    name:            Symbol,
    artifacts:       Hash,
    registries:      Hash,
    env_files:       Hash,
    templates:       Hash,
    kubeconfig_path: Maybe[String],
    deploy_strategy: Symbol,
    services_attributes: HashOf[Symbol => Hash],
    build_servers:   ArrayOf[KuberKit::Core::BuildServers::AbstractBuildServer]
  ] => Any
  def initialize(name:, artifacts:, registries:, env_files:, templates:, kubeconfig_path:, 
                 deploy_strategy:, services_attributes:, build_servers:)
    @name             = name
    @artifacts        = artifacts
    @registries       = registries
    @env_files        = env_files
    @templates        = templates
    @kubeconfig_path  = kubeconfig_path
    @deploy_strategy  = deploy_strategy
    @services_attributes = services_attributes
    @build_servers    = build_servers
  end

  def service_attributes(service_name)
    services_attributes[service_name.to_sym] || {}
  end
end