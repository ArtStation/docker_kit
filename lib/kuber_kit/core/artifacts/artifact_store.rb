class KuberKit::Core::Artifacts::ArtifactStore
  def add(artifact)
    store.add(artifact.name, artifact)
  end

  def get(artifact_name)
    artifact = get_from_configuration(artifact_name) || 
               get_global(artifact_name)

    artifact
  end

  def get_global(artifact_name)
    store.get(artifact_name)
  end

  def get_from_configuration(artifact_name)
    artifacts = KuberKit.current_configuration.artifacts
    artifacts[artifact_name]
  end

  def reset!
    store.reset!
  end

  def exists?(artifact_name)
    store.exists?(artifact_name)
  end

  private
    def store
      @@store ||= KuberKit::Core::Store.new(KuberKit::Core::Artifacts::AbstractArtifact)
    end
end