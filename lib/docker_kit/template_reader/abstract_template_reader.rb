class DockerKit::TemplateReader::AbstractTemplateReader
  def read(shell, template)
    raise DockerKit::NotImplementedError, "must be implemented"
  end
end