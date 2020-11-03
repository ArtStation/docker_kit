class KuberKit::ServiceDeployer::StrategyDetector
  Contract KuberKit::Core::Service => Symbol
  def call(service)
    KuberKit.current_configuration.deploy_strategy
  end
end