class Indocker::Actions::ServiceReader
  include Indocker::Import[
    "core.service_store",
    "service_handler.service_reader",
    "shell.local_shell",
    "ui"
  ]

  Contract Symbol, Hash => Any
  def call(service_name, options)
    service = service_store.get_service(service_name)

    result = service_reader.read(local_shell, service)

    ui.print_info(service_name.to_s, result)
  end
end