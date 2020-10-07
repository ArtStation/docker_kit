class Indocker::Core::ConfigurationFactory
  NotFoundError = Class.new(Indocker::NotFoundError)

  include Indocker::Import[
    "core.registry_store",
    "core.repository_store"
  ]

  def create(definition)
    configuration_attrs = definition.to_attrs

    repositories = fetch_repositories(configuration_attrs.repositories)
    registries = fetch_registries(configuration_attrs.registries)

    Indocker::Core::Configuration.new(
      name:           configuration_attrs.name,
      repositories:   repositories,
      registries:     registries,
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

    def fetch_repositories(repositories)
      result = {}
      repositories.each do |repo_alias, repo_name|
        result[repo_alias] = repository_store.get_global(repo_name)
      end
      result
    end
end