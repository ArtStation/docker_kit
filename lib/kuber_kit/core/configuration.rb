class KuberKit::Core::Configuration
  attr_reader :name, :artifacts, :registries, :env_files, :templates, :kubeconfig_path, :kubectl_entrypoint,
              :services_attributes, :enabled_services, :disabled_services, :default_services,
              :pre_deploy_services, :post_deploy_services, :build_servers, :global_build_vars,
              :deployer_strategy, :deployer_namespace, :deployer_require_confirmation,
              :shell_launcher_strategy

  Contract KeywordArgs[
    name:                 Symbol,
    artifacts:            Hash,
    registries:           Hash,
    env_files:            Hash,
    templates:            Hash,
    kubeconfig_path:      Maybe[Or[String, KuberKit::Core::ArtifactPath]],
    kubectl_entrypoint:   Maybe[String],
    services_attributes:  HashOf[Symbol => Hash],
    enabled_services:     ArrayOf[Symbol],
    disabled_services:    ArrayOf[Symbol],
    default_services:     ArrayOf[Symbol],
    pre_deploy_services:  ArrayOf[Symbol],
    post_deploy_services: ArrayOf[Symbol],
    build_servers:        ArrayOf[KuberKit::Core::BuildServers::AbstractBuildServer],
    global_build_vars:    HashOf[Symbol => Any],
    deployer_strategy:              Symbol,
    deployer_namespace:             Maybe[Or[Symbol, String]],
    deployer_require_confirmation:  Bool,
    shell_launcher_strategy:        Symbol,
  ] => Any
  def initialize(name:, artifacts:, registries:, env_files:, templates:, kubeconfig_path:, kubectl_entrypoint:,
                 services_attributes:, enabled_services:, disabled_services:, default_services:, 
                 pre_deploy_services:, post_deploy_services:, build_servers:, global_build_vars:,
                 deployer_strategy:, deployer_namespace:, deployer_require_confirmation:, shell_launcher_strategy:)
    @name                 = name
    @artifacts            = artifacts
    @registries           = registries
    @env_files            = env_files
    @templates            = templates
    @kubeconfig_path      = kubeconfig_path
    @kubectl_entrypoint   = kubectl_entrypoint
    @build_servers        = build_servers
    @services_attributes  = services_attributes
    @enabled_services     = enabled_services
    @disabled_services    = disabled_services
    @default_services     = default_services
    @pre_deploy_services  = pre_deploy_services
    @post_deploy_services = post_deploy_services
    @global_build_vars    = global_build_vars
    @deployer_strategy              = deployer_strategy
    @deployer_namespace             = deployer_namespace
    @deployer_require_confirmation  = deployer_require_confirmation
    @shell_launcher_strategy        = shell_launcher_strategy
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
