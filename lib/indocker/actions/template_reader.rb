class Indocker::Actions::TemplateReader
  include Indocker::Import[
    "core.template_store",
    "core.context_helper_factory",
    "template_reader.reader",
    "shell.local_shell",
    "ui"
  ]

  Contract Symbol, Hash => Any
  def call(template_name, options)
    template = template_store.get(template_name)
    context_helper = context_helper_factory.build_image_context(local_shell)

    result = reader.read(local_shell, template)

    ui.print_info(template_name.to_s, result)
  end
end