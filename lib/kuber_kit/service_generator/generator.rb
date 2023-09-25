class KuberKit::ServiceGenerator::Generator
  StrategyNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "core.service_store",
  ]

  def register_strategy(strategy_name, strategy)
    @@strategies ||= {}

    if !strategy.is_a?(KuberKit::ServiceGenerator::Strategies::Abstract)
      raise ArgumentError.new("should be an instance of KuberKit::ServiceGenerator::Strategies::Abstract, got: #{strategy.inspect}")
    end

    @@strategies[strategy_name] = strategy
  end

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service, String, Symbol => Any
  def generate(shell, service, export_path, strategy_name)
    generator = @@strategies[strategy_name]

    raise StrategyNotFoundError, "Can't find strategy with name #{strategy_name}" if generator.nil?

    generator.generate(shell, service, export_path)
  end
end