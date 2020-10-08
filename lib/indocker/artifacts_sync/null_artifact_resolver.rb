class Indocker::ArtifactsSync::NullArtifactResolver < Indocker::ArtifactsSync::AbstractArtifactResolver

  Contract Indocker::Shell::AbstractShell, Any => Any
  def resolve(shell, artifact)
    return true
  end
end