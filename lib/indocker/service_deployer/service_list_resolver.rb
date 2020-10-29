class Indocker::ServiceDeployer::ServiceListResolver
  include Indocker::Import[
    "core.service_store"
  ]

  Contract KeywordArgs[
    name:     Optional[Maybe[String]],
    services: Optional[ArrayOf[Symbol]],
    tags:     Optional[ArrayOf[Symbol]]
  ] => ArrayOf[Symbol]
  def resolve(name: nil, services: [], tags: [])
    all_definitions = service_store.all_definitions.values
    
    included_definitions = all_definitions.select do |definition|
      services.include?(definition.service_name) ||
      (tags & definition.to_service_attrs.tags).any?
    end

    included_definitions.map(&:service_name)
  end
end