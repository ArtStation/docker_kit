class KuberKit::Actions::ServiceReader
  include KuberKit::Import[
    "shell.local_shell",
    "ui",
    service_reader: "service_reader.action_handler",
  ]

  Contract Symbol, Hash => Any
  def call(service_name, options)
    result = service_reader.call(local_shell, service_name)

    ui.print_info(service_name.to_s, result)
  end
end