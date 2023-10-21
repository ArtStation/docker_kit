class KuberKit::TemplateReader::Renderer
  include KuberKit::Import[
    "core.template_store",
    "preprocessing.text_preprocessor",
    template_reader: "template_reader.reader"
  ]


  Contract KuberKit::Shell::AbstractShell, Symbol, KeywordArgs[
    context_helper: KuberKit::Core::ContextHelper::AbstractHelper
  ] => String
  def call(shell, template_name, context_helper:)
    template = template_store.get(template_name)
    template_text = template_reader.read(shell, template)
    text_preprocessor.compile(template_text, context_helper: context_helper)
  end
end