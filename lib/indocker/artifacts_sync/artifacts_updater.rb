class Indocker::ArtifactsSync::ArtifactsUpdater
  ResolverNotFoundError = Class.new(Indocker::NotFoundError)

  include Indocker::Import[
    "artifacts_sync.git_artifact_resolver"
  ]

  def use_resolver(artifact_resolver, artifact_class:)
    @@resolvers ||= {}
    @@resolvers[artifact_class] = artifact_resolver
  end

  def update(shell, artifacts)
    add_default_resolvers
    
    artifacts.each do |artifact|
      resolver = @@resolvers[artifact.class]
      
      raise ResolverNotFoundError, "Can't find resolver for artifact #{artifact}" if resolver.nil?

      resolver.resolve(shell, artifact)
    end
  end

  def add_default_resolvers
    use_resolver(git_artifact_resolver, artifact_class: Indocker::Core::Artifacts::Git)
  end

  def reset!
    @@resolvers = {}
  end
end