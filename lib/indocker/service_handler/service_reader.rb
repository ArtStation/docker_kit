class Indocker::ServiceHandler::ServiceReader
  include Indocker::Import[
    "core.template_store",
    "core.context_helper_factory",
    "template_reader.reader",
    "shell.local_shell",
  ]

  def read(shell, service)
    template = template_store.get(service.template_name)

    context_helper = context_helper_factory.build_service_context(local_shell, service)

    result = reader.read(local_shell, template, context_helper: context_helper)

    result
  end
end