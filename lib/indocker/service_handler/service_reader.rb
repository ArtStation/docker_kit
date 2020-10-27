class Indocker::ServiceHandler::ServiceReader
  include Indocker::Import[
    "core.template_store"
  ]

  def read(shell, service)
    template = template_store.get(service.template_name)
  end
end