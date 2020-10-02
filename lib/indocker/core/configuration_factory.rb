class Indocker::Core::ConfigurationFactory
  NotFoundError = Class.new(StandardError)

  include Indocker::Import[
    "core.infra_store"
  ]

  def create(definition)
    configuration_attrs = definition.to_attrs

    # repositories = fetch_repositories(configuration_attrs.repositories)
    registries = fetch_registries(configuration_attrs.registries)

    Indocker::Core::Configuration.new(
      name:           configuration_attrs.name,
      repositories:   configuration_attrs.repositories,
      registries:     registries,
    )
  end

  private
    def fetch_registries(registries)
      result = {}
      registries.each do |registry_alias, registry_name|
        result[registry_alias] = infra_store.get_registry(registry_name)
      end
      result
    end
end