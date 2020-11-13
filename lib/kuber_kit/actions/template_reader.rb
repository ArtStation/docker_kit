class KuberKit::Actions::TemplateReader
  include KuberKit::Import[
    "core.template_store",
    "template_reader.reader",
    "shell.local_shell",
    "ui"
  ]

  Contract Symbol, Hash => Any
  def call(template_name, options)
    template = template_store.get(template_name)

    result = reader.read(local_shell, template)

    ui.print_info(template_name.to_s, result)

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    false
  end
end