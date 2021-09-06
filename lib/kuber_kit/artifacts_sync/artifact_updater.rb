class KuberKit::ArtifactsSync::ArtifactUpdater
  ResolverNotFoundError = Class.new(KuberKit::NotFoundError)

  include KuberKit::Import[
    "ui"
  ]

  def use_resolver(artifact_resolver, artifact_class:)
    @@resolvers ||= {}

    if !artifact_resolver.is_a?(KuberKit::ArtifactsSync::AbstractArtifactResolver)
      raise ArgumentError.new("should be an instance of KuberKit::ArtifactsSync::AbstractArtifactResolver, got: #{artifact_resolver.inspect}")
    end

    @@resolvers[artifact_class] = artifact_resolver
  end

  def update(shell, artifact)
    resolver = @@resolvers[artifact.class]

    ui.print_debug "ArtifactUpdater", "Updating artifact #{artifact.name.to_s.green}"
    
    raise ResolverNotFoundError, "Can't find resolver for artifact #{artifact}" if resolver.nil?

    resolver.resolve(shell, artifact)
  end
end