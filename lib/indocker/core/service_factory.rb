class Indocker::Core::ServiceFactory
  def create(definition)
    service_attrs = definition.to_service_attrs

    Indocker::Core::Service.new(
      name:  service_attrs.name,
    )
  end
end