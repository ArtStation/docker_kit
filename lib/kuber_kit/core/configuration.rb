class KuberKit::Core::Configuration
  attr_reader :name, :artifacts, :registries, :env_files, :templates, :kubeconfig_path, 
              :deployer_strategy, :deployer_namespace, :services_attributes, :build_servers,
              :global_build_vars

  Contract KeywordArgs[
    name:            Symbol,
    artifacts:       Hash,
    registries:      Hash,
    env_files:       Hash,
    templates:       Hash,
    kubeconfig_path: Maybe[String],
    deployer_strategy:  Symbol,
    deployer_namespace: Maybe[Symbol],
    services_attributes: HashOf[Symbol => Hash],
    build_servers:   ArrayOf[KuberKit::Core::BuildServers::AbstractBuildServer],
    global_build_vars:   HashOf[Symbol => Any],
  ] => Any
  def initialize(name:, artifacts:, registries:, env_files:, templates:, kubeconfig_path:, 
                 deployer_strategy:, deployer_namespace:, services_attributes:, build_servers:, 
                 global_build_vars:)
    @name             = name
    @artifacts        = artifacts
    @registries       = registries
    @env_files        = env_files
    @templates        = templates
    @kubeconfig_path  = kubeconfig_path
    @deployer_strategy  = deployer_strategy
    @deployer_namespace = deployer_namespace
    @build_servers    = build_servers
    @services_attributes  = services_attributes
    @global_build_vars    = global_build_vars
  end

  def service_attributes(service_name)
    services_attributes[service_name.to_sym] || {}
  end

  def global_build_args
    unless KuberKit.deprecation_warnings_disabled?
      puts "DEPRECATION: global_build_args is deprecated, please use global_build_vars instead"
    end
    global_build_vars
  end
end