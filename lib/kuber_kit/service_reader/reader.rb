class KuberKit::ServiceReader::Reader
  include KuberKit::Import[
    "core.context_helper_factory",
    "template_reader.renderer"
  ]

  AttributeNotSetError = Class.new(KuberKit::Error)

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def read(shell, service)
    if service.template_name.nil?
      raise AttributeNotSetError, "Please set template for service using #template method"
    end

    context_helper = context_helper_factory.build_service_context(shell, service)

    renderer.call(shell, service.template_name, context_helper: context_helper)
  end
end