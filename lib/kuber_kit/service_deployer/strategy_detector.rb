class KuberKit::ServiceDeployer::StrategyDetector
  Contract KuberKit::Core::Service => Symbol
  def call(service)
    service.deployer_strategy || KuberKit.current_configuration.deployer_strategy
  end
end