class DockerKit::ArtifactsSync::AbstractArtifactResolver
  def resolve(shell, artifact)
    raise DockerKit::NotImplementedError, "must be implemented"
  end
end