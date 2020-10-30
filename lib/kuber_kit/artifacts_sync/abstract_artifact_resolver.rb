class KuberKit::ArtifactsSync::AbstractArtifactResolver
  def resolve(shell, artifact)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end