class Indocker::Core::ConfigurationFactory
  NotFoundError = Class.new(Indocker::NotFoundError)

  include Indocker::Import[
    "core.registry_store",
    "core.artifact_store",
    "core.env_file_store",
    "core.template_store"
  ]

  def create(definition)
    configuration_attrs = definition.to_attrs

    artifacts  = fetch_artifacts(configuration_attrs.artifacts)
    registries = fetch_registries(configuration_attrs.registries)
    env_files  = fetch_env_files(configuration_attrs.env_files)
    templates  = fetch_templates(configuration_attrs.templates)

    Indocker::Core::Configuration.new(
      name:           configuration_attrs.name,
      artifacts:      artifacts,
      registries:     registries,
      env_files:      env_files,
      templates:      templates,
      kubecfg_path:   configuration_attrs.kubecfg_path
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
end