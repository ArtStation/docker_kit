class KuberKit::ServiceDeployer::ServiceReader
  include KuberKit::Import[
    "core.template_store",
    "core.context_helper_factory",
    "template_reader.reader",
    "preprocessing.text_preprocessor"
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def read(shell, service)
    template = template_store.get(service.template_name)

    context_helper = context_helper_factory.build_service_context(shell, service)

    template = reader.read(shell, template)

    result = text_preprocessor.compile(template, context_helper: context_helper)

    result
  end
end