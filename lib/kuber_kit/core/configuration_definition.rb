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
  end

  def to_attrs
    OpenStruct.new(
      name:          @configuration_name,
      artifacts:     @artifacts,
      registries:    @registries,
      env_files:     @env_files,
      templates:     @templates,
      kubecfg_path:  @kubecfg_path
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

  def kubecfg_path(path)
    @kubecfg_path = path

    self
  end
end