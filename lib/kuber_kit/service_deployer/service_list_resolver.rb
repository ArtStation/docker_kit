class KuberKit::ServiceDeployer::ServiceListResolver
  include KuberKit::Import[
    "core.service_store"
  ]

  Contract KeywordArgs[
    services:         Optional[ArrayOf[String]],
    tags:             Optional[ArrayOf[String]],
    enabled_services: Optional[ArrayOf[String]]
  ] => ArrayOf[String]
  def resolve(services: [], tags: [], enabled_services: [])
    all_definitions = service_store.all_definitions.values

    included_services, excluded_services = split_by_inclusion(services)
    included_tags,     excluded_tags     = split_by_inclusion(tags)
    
    included_definitions = all_definitions.select do |definition|
      service_name = definition.service_name.to_s
      service_tags = definition.to_service_attrs.tags.map(&:to_s)

      matches_any?([service_name], included_services) ||
      matches_any?(service_tags, included_tags)
    end

    included_definitions = included_definitions.reject do |definition|
      service_name = definition.service_name.to_s
      service_tags = definition.to_service_attrs.tags.map(&:to_s)

      matches_any?([service_name], excluded_services) ||
      matches_any?(service_tags, excluded_tags)
    end

    included_services = included_definitions.map(&:service_name).map(&:to_s)

    if enabled_services.any?
      included_services = included_services.select{ |s| enabled_services.include?(s) }
    end

    included_services
  end

  Contract Array => Array
  def split_by_inclusion(array)
    excluded, included = array.partition{|e| e.start_with?('-') }

    excluded.map!{ |item| item.gsub(/^\-/, "") }

    [included, excluded]
  end

  Contract String, String => Bool
  def matches_name?(name, pattern)
    regexp = Regexp.new("\\A" + pattern.gsub("*", "[a-z\_0-9]+") + "\\z")
    name.match?(regexp)
  end

  Contract ArrayOf[String], ArrayOf[String] => Bool
  def matches_any?(names, patterns)
    patterns.any? do |pattern|
      names.any? { |name| matches_name?(name, pattern) }
    end
  end
end