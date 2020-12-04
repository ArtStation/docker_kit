class KuberKit::TemplateReader::Strategies::Abstract
  def read(shell, template)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end