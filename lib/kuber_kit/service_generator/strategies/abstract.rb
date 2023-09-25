class KuberKit::ServiceGenerator::Strategies::Abstract
  def generate(shell, service, export_path)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end