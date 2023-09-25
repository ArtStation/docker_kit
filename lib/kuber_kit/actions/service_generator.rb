class KuberKit::Actions::ServiceGenerator
  include KuberKit::Import[
    "shell.local_shell",
    "service_generator.action_handler",
    "ui",
  ]

  Contract Symbol, String => Any
  def call(service_name, path)
    expanded_path = File.expand_path(path)
    puts expanded_path
    action_handler.call(local_shell, service_name, expanded_path)

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end