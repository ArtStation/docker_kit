class DockerKit::ArtifactsSync::NullArtifactResolver < DockerKit::ArtifactsSync::AbstractArtifactResolver

  Contract DockerKit::Shell::AbstractShell, Any => Any
  def resolve(shell, artifact)
    return true
  end
end