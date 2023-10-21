class KuberKit::TemplateReader::Renderer
  include KuberKit::Import[
    "core.template_store",
    "template_reader.reader",
    "preprocessing.text_preprocessor"
  ]


  Contract KuberKit::Shell::AbstractShell, Symbol, KeywordArgs[
    context_helper: KuberKit::Core::ContextHelper::BaseHelper
  ] => String
  def render(shell, template_name, context_helper:)
    template = template_store.get(template_name)
    template_text = reader.read(shell, template)
    text_preprocessor.compile(template_text, context_helper: context_helper)
  end
end