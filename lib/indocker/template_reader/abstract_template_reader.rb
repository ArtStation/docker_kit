class Indocker::TemplateReader::AbstractTemplateReader
  def read(shell, template)
    raise Indocker::NotImplementedError, "must be implemented"
  end
end