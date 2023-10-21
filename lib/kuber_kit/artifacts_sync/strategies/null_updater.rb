class KuberKit::ArtifactsSync::Strategies::NullUpdater < KuberKit::ArtifactsSync::Strategies::Abstract

  Contract KuberKit::Shell::AbstractShell, Any => Any
  def update(shell, artifact)
    return true
  end

  Contract KuberKit::Shell::AbstractShell, Any => Any
  def cleanup(shell, artifact)
    return true
  end
end