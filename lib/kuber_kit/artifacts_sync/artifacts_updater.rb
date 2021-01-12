class KuberKit::ArtifactsSync::ArtifactsUpdater
  ResolverNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "artifacts_sync.git_artifact_resolver",
    "artifacts_sync.null_artifact_resolver",

    "ui"
  ]

  def use_resolver(artifact_resolver, artifact_class:)
    @@resolvers ||= {}

    if !artifact_resolver.is_a?(KuberKit::ArtifactsSync::AbstractArtifactResolver)
      raise ArgumentError.new("should be an instance of KuberKit::ArtifactsSync::AbstractArtifactResolver, got: #{artifact_resolver.inspect}")
    end

    @@resolvers[artifact_class] = artifact_resolver
  end

  def update(shell, artifacts)
    add_default_resolvers

    artifacts.each do |artifact|
      resolver = @@resolvers[artifact.class]

      ui.print_debug "ArtifactUpdater", "Updating artifact #{artifact.name.to_s.green}"
      
      raise ResolverNotFoundError, "Can't find resolver for artifact #{artifact}" if resolver.nil?

      resolver.resolve(shell, artifact)
    end
  end

  def add_default_resolvers
    use_resolver(git_artifact_resolver, artifact_class: KuberKit::Core::Artifacts::Git)
    use_resolver(null_artifact_resolver, artifact_class: KuberKit::Core::Artifacts::Local)
  end

  def reset!
    @@resolvers = {}
  end
end