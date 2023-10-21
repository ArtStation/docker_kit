class KuberKit::ArtifactsSync::ArtifactUpdater
  StrategyNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "ui"
  ]

  def use_strategy(strategy, artifact_class:)
    @@strategies ||= {}

    if !strategy.is_a?(KuberKit::ArtifactsSync::Strategies::Abstract)
      raise ArgumentError.new("should be an instance of KuberKit::ArtifactsSync::Strategies::Abstract, got: #{strategy.inspect}")
    end

    @@strategies[artifact_class] = strategy
  end

  def update(shell, artifact)
    strategy = @@strategies[artifact.class]

    ui.print_debug "ArtifactUpdater", "Updating artifact #{artifact.name.to_s.green}"
    
    raise StrategyNotFoundError, "Can't find strategy for artifact #{artifact}" if strategy.nil?

    strategy.update(shell, artifact)
  end

  def cleanup(shell, artifact)
    strategy = @@strategies[artifact.class]

    ui.print_debug "ArtifactUpdater", "Cleaning artifact #{artifact.name.to_s.green}"
    
    raise StrategyNotFoundError, "Can't find strategy for artifact #{artifact}" if strategy.nil?

    strategy.cleanup(shell, artifact)
  end
end