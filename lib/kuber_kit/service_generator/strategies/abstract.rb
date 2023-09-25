class KuberKit::ServiceGenerator::Strategies::Abstract
  def generate(shell, service)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end