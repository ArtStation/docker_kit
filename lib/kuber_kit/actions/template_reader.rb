class KuberKit::Actions::TemplateReader
  include KuberKit::Import[
    "shell.local_shell",
    "ui",
    template_reader: "template_reader.action_handler",
  ]

  Contract Symbol, Hash => Any
  def call(template_name, options)
    result = template_reader.call(local_shell, template_name)

    ui.print_info(template_name.to_s, result)

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    false
  end
end