class KuberKit::ArtifactsSync::NullArtifactResolver < KuberKit::ArtifactsSync::AbstractArtifactResolver

  Contract KuberKit::Shell::AbstractShell, Any => Any
  def resolve(shell, artifact)
    return true
  end
end