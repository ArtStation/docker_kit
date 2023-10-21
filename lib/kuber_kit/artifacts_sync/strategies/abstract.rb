class KuberKit::ArtifactsSync::Strategies::Abstract
  def update(shell, artifact)
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def cleanup(shell, artifact)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end