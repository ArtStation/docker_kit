class KuberKit::TemplateReader::ActionHandler
  include KuberKit::Import[
    "template_reader.reader",
    "core.template_store",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol => Any
  def call(shell, template_name)
    template = template_store.get(template_name)

    reader.read(shell, template)
  end
end