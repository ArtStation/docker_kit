class KuberKit::TemplateReader::AbstractTemplateReader
  def read(shell, template)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end