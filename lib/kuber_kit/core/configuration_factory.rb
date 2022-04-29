class KuberKit::Core::ConfigurationFactory
  NotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "core.registry_store",
    "core.artifact_store",
    "core.env_file_store",
    "core.template_store",
    "core.build_server_store",
    "configs"
  ]

  def create(definition)
    configuration_attrs = definition.to_attrs

    artifacts  = fetch_artifacts(configuration_attrs.artifacts)
    registries = fetch_registries(configuration_attrs.registries)
    env_files  = fetch_env_files(configuration_attrs.env_files)
    templates  = fetch_templates(configuration_attrs.templates)
    build_servers = fetch_build_servers(configuration_attrs.build_servers)

    KuberKit::Core::Configuration.new(
      name:                 configuration_attrs.name,
      artifacts:            artifacts,
      registries:           registries,
      env_files:            env_files,
      templates:            templates,
      kubeconfig_path:      configuration_attrs.kubeconfig_path,
      kubectl_entrypoint:   configuration_attrs.kubectl_entrypoint,
      build_servers:        build_servers,
      services_attributes:  configuration_attrs.services_attributes,
      enabled_services:     configuration_attrs.enabled_services,
      disabled_services:    configuration_attrs.disabled_services,
      default_services:     configuration_attrs.default_services,
      initial_services:     configuration_attrs.initial_services,
      global_build_vars:    configuration_attrs.global_build_vars || {},
      deployer_strategy:              configuration_attrs.deployer_strategy || configs.deployer_strategy,
      deployer_namespace:             configuration_attrs.deployer_namespace,
      deployer_require_confirmation:  configuration_attrs.deployer_require_confirmation,
      shell_launcher_strategy:        configuration_attrs.shell_launcher_strategy || configs.shell_launcher_strategy,
    )
  end

  private
    def fetch_registries(registries)
      result = {}
      registries.each do |registry_alias, registry_name|
        result[registry_alias] = registry_store.get_global(registry_name)
      end
      result
    end

    def fetch_artifacts(artifacts)
      result = {}
      artifacts.each do |artifact_alias, artifact_name|
        result[artifact_alias] = artifact_store.get_global(artifact_name)
      end
      result
    end

    def fetch_env_files(env_files)
      result = {}
      env_files.each do |env_file_alias, env_file_name|
        result[env_file_alias] = env_file_store.get_global(env_file_name)
      end
      result
    end

    def fetch_templates(templates)
      result = {}
      templates.each do |template_alias, template_name|
        result[template_alias] = template_store.get_global(template_name)
      end
      result
    end

    def fetch_build_servers(build_servers)
      build_servers.map do |build_server_name|
        build_server_store.get(build_server_name)
      end
    end
end