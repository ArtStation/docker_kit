class KuberKit::ServiceDeployer::ServiceRestarter
  StrategyNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "core.service_store",
    "service_deployer.strategies.kubernetes"
  ]

  def register_strategy(strategy_name, strategy)
    @@strategies ||= {}

    if !strategy.is_a?(KuberKit::ServiceDeployer::Strategies::Abstract)
      raise ArgumentError.new("should be an instance of KuberKit::ServiceDeployer::Strategies::Abstract, got: #{strategy.inspect}")
    end

    @@strategies[strategy_name] = strategy
  end

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service, Symbol => Any
  def restart(shell, service, strategy_name)
    add_default_strategies

    restarter = @@strategies[strategy_name]

    raise StrategyNotFoundError, "Can't find strategy with name #{strategy_name}" if restarter.nil?

    restarter.restart(shell, service)
  end

  def add_default_strategies
    register_strategy(:kubernetes, kubernetes)
  end

  def reset!
    @@strategies = {}
  end
end