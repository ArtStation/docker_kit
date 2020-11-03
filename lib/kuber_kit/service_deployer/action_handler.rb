class KuberKit::ServiceDeployer::ActionHandler
  include KuberKit::Import[
    "service_deployer.deployer",
    "service_deployer.strategy_detector",
    "core.service_store",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def call(shell, service_name)
    service = service_store.get_service(service_name)

    strategy_name = strategy_detector.call(service)

    deployer.restart(shell, service, strategy_name)
  end
end