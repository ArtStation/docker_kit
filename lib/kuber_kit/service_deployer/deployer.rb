class KuberKit::ServiceDeployer::Deployer
  StrategyNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "core.service_store",
  ]

  def register_strategy(strategy_name, strategy)
    @@strategies ||= {}

    if !strategy.is_a?(KuberKit::ServiceDeployer::Strategies::Abstract)
      raise ArgumentError.new("should be an instance of KuberKit::ServiceDeployer::Strategies::Abstract, got: #{strategy.inspect}")
    end

    @@strategies[strategy_name] = strategy
  end

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service, Symbol => Any
  def deploy(shell, service, strategy_name)
    deployer = @@strategies[strategy_name]

    raise StrategyNotFoundError, "Can't find strategy with name #{strategy_name}" if deployer.nil?

    deployer.deploy(shell, service)
  end
end