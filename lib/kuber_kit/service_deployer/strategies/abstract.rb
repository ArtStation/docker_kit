class KuberKit::ServiceDeployer::Strategies::Abstract
  def deploy(shell, service)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end