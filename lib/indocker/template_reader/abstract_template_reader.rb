class Indocker::TemplateReader::AbstractTemplateReader
  def read(shell, template, context_helper: nil)
    raise Indocker::NotImplementedError, "must be implemented"
  end
end