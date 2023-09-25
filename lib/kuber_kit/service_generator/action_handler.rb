class KuberKit::ServiceGenerator::ActionHandler
  include KuberKit::Import[
    "service_generator.generator",
    "service_generator.strategy_detector",
    "core.service_store",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol, String => Any
  def call(shell, service_name, export_path)
    service = service_store.get_service(service_name)

    strategy_name = strategy_detector.call(service)

    generator.generate(shell, service, export_path, strategy_name)
  end
end