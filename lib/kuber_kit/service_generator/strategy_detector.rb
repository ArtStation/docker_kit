class KuberKit::ServiceGenerator::StrategyDetector
  Contract KuberKit::Core::Service => Symbol
  def call(service)
    service.generator_strategy || KuberKit.current_configuration.generator_strategy
  end
end