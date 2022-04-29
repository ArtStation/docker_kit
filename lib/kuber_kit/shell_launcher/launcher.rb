class KuberKit::ShellLauncher::Launcher
  StrategyNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "core.service_store",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def call(shell, strategy_name)
    launcher = get_strategy(strategy_name)

    raise StrategyNotFoundError, "Can't find strategy with name #{strategy_name}" if launcher.nil?

    launcher.call(shell)
  end

  def register_strategy(strategy_name, strategy)
    @@strategies ||= {}

    if !strategy.is_a?(KuberKit::ShellLauncher::Strategies::Abstract)
      raise ArgumentError.new("should be an instance of KuberKit::ShellLauncher::Strategies::Abstract, got: #{strategy.inspect}")
    end

    @@strategies[strategy_name] = strategy
  end

  def get_strategy(strategy_name)
    @@strategies ||= {}
    @@strategies[strategy_name]
  end
end