class KuberKit::ServiceDeployer::Deployer
  include KuberKit::Import[
    "service_deployer.service_restarter",
    "core.service_store",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def deploy(shell, service_name)
    service = service_store.get_service(service_name)

    strategy_name = KuberKit.current_configuration.deploy_strategy

    service_restarter.restart(shell, service, strategy_name)
  end
end