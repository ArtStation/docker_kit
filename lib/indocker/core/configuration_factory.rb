class Indocker::Core::ConfigurationFactory
  NotFoundError = Class.new(Indocker::NotFoundError)

  include Indocker::Import[
    "core.registry_store",
    "core.artifact_store",
    "core.env_file_store"
  ]

  def create(definition)
    configuration_attrs = definition.to_attrs

    artifacts  = fetch_artifacts(configuration_attrs.artifacts)
    registries = fetch_registries(configuration_attrs.registries)
    env_files  = fetch_env_files(configuration_attrs.env_files)

    Indocker::Core::Configuration.new(
      name:           configuration_attrs.name,
      artifacts:      artifacts,
      registries:     registries,
      env_files:      env_files
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
end