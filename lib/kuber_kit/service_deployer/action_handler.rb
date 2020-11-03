class KuberKit::ServiceDeployer::ActionHandler
  include KuberKit::Import[
    "service_deployer.deployer",
    "core.service_store",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def call(shell, service_name)
    service = service_store.get_service(service_name)

    strategy_name = KuberKit.current_configuration.deploy_strategy

    deployer.restart(shell, service, strategy_name)
  end
end