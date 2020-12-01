class KuberKit::ServiceDeployer::StrategyDetector
  Contract KuberKit::Core::Service => Symbol
  def call(service)
    service.deploy_strategy || KuberKit.current_configuration.deploy_strategy
  end
end