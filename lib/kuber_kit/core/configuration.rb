class KuberKit::Core::Configuration
  attr_reader :name, :artifacts, :registries, :env_files, :templates, :kubeconfig_path, 
              :services_attributes, :enabled_services, :build_servers, :global_build_vars,
              :deployer_strategy, :deployer_namespace, :deployer_require_confirimation

  Contract KeywordArgs[
    name:                 Symbol,
    artifacts:            Hash,
    registries:           Hash,
    env_files:            Hash,
    templates:            Hash,
    kubeconfig_path:      Maybe[String],
    services_attributes:  HashOf[Symbol => Hash],
    enabled_services:     ArrayOf[Symbol],
    build_servers:        ArrayOf[KuberKit::Core::BuildServers::AbstractBuildServer],
    global_build_vars:    HashOf[Symbol => Any],
    deployer_strategy:              Symbol,
    deployer_namespace:             Maybe[Symbol],
    deployer_require_confirimation: Bool,
  ] => Any
  def initialize(name:, artifacts:, registries:, env_files:, templates:, kubeconfig_path:, 
                 services_attributes:, enabled_services:, build_servers:, global_build_vars:,
                 deployer_strategy:, deployer_namespace:, deployer_require_confirimation:)
    @name                 = name
    @artifacts            = artifacts
    @registries           = registries
    @env_files            = env_files
    @templates            = templates
    @kubeconfig_path      = kubeconfig_path
    @build_servers        = build_servers
    @services_attributes  = services_attributes
    @enabled_services     = enabled_services
    @global_build_vars    = global_build_vars
    @deployer_strategy              = deployer_strategy
    @deployer_namespace             = deployer_namespace
    @deployer_require_confirimation = deployer_require_confirimation
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