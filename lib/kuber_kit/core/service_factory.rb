class KuberKit::Core::ServiceFactory
  def create(definition)
    service_attrs = definition.to_service_attrs

    configuration_attributes = KuberKit.current_configuration.service_attributes(service_attrs.name)
    attributes = (service_attrs.attributes || {}).merge(configuration_attributes)

    KuberKit::Core::Service.new(
      name:               service_attrs.name,
      initializers:       service_attrs.initializers,
      template_name:      service_attrs.template_name,
      tags:               service_attrs.tags,
      images:             service_attrs.images,
      attributes:         attributes,
      deployer_strategy:  service_attrs.deployer_strategy,
      generator_strategy: service_attrs.generator_strategy,
    )
  end
end