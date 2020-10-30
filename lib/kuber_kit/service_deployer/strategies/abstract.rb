class KuberKit::ServiceDeployer::Strategies::Abstract
  def restart(shell, service)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end