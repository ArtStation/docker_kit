class KuberKit::Core::ConfigurationDefinition
  ResourceAlreadyAdded = Class.new(KuberKit::Error)

  attr_reader :configuration_name

  Contract Or[Symbol, String] => Any
  def initialize(configuration_name)
    @configuration_name = configuration_name.to_sym
    @artifacts  = {}
    @registries = {}
    @env_files  = {}
    @templates  = {}
    @build_servers      = []
    @enabled_services   = []
    @services_attributes = {}
  end

  def to_attrs
    OpenStruct.new(
      name:                 @configuration_name,
      artifacts:            @artifacts,
      registries:           @registries,
      env_files:            @env_files,
      templates:            @templates,
      kubeconfig_path:      @kubeconfig_path,
      enabled_services:     @enabled_services,
      build_servers:        @build_servers,
      services_attributes:  @services_attributes,
      global_build_vars:    @global_build_vars,
      deployer_strategy:              @deployer_strategy,
      deployer_namespace:             @deployer_namespace,
      deployer_require_confirimation: @deployer_require_confirimation || false,
    )
  end

  def use_artifact(artifact_name, as:)
    if @artifacts.has_key?(as)
      raise ResourceAlreadyAdded.new("alias name :#{as} is already used by artifact: #{@artifacts[as].inspect}")
    end
    @artifacts[as] = artifact_name

    self
  end

  def use_registry(registry_name, as:)
    if @registries.has_key?(as)
      raise ResourceAlreadyAdded.new("alias name :#{as} is already used by registry: #{@registries[as].inspect}")
    end
    @registries[as] = registry_name

    self
  end

  def use_env_file(env_file_name, as:)
    if @env_files.has_key?(as)
      raise ResourceAlreadyAdded.new("alias name :#{as} is already used by env_file: #{@env_files[as].inspect}")
    end
    @env_files[as] = env_file_name

    self
  end

  def use_template(template_name, as:)
    if @templates.has_key?(as)
      raise ResourceAlreadyAdded.new("alias name :#{as} is already used by template: #{@templates[as].inspect}")
    end
    @templates[as] = template_name

    self
  end

  def use_build_server(build_server_name)
    unless @build_servers.include?(build_server_name)
      @build_servers.push(build_server_name)
    end

    self
  end

  def kubeconfig_path(path)
    @kubeconfig_path = path

    self
  end

  def deployer_namespace(namespace)
    @deployer_namespace = namespace

    self
  end

  def deployer_strategy(path)
    @deployer_strategy = path

    self
  end

  def deployer_require_confirimation
    @deployer_require_confirimation = true

    self
  end

  def enabled_services(services)
    if services.is_a?(Hash)
      @enabled_services += services.keys.map(&:to_sym)
      @services_attributes = @services_attributes.merge(services)
      return self
    end

    if services.is_a?(Array)
      @enabled_services += services.map(&:to_sym)
      return self
    end

    raise KuberKit::Error, "#enabled_services method accepts only Array or Hash"
  end

  def service_attributes(services)
    @services_attributes = @services_attributes.merge(services)
    self
  end

  def global_build_vars(variables)
    @global_build_vars = variables

    self
  end
end