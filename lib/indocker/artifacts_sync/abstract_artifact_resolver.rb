class Indocker::ArtifactsSync::AbstractArtifactResolver
  def resolve(shell, artifact)
    raise Indocker::NotImplementedError, "must be implemented"
  end
end