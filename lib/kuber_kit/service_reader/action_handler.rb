class KuberKit::ServiceReader::ActionHandler
  include KuberKit::Import[
    "service_reader.reader",
    "core.service_store",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def call(shell, service_name)
    service = service_store.get_service(service_name)

    reader.read(shell, service)
  end
end