class KuberKit::Actions::ServiceChecker
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "core.service_store",
    "ui",
  ]

  Contract Hash => Any
  def call(options)
    services = service_store.all_definitions.values.map(&:service_name).map(&:to_s)

    enabled_services  = KuberKit.current_configuration.enabled_services.map(&:to_s)
    if enabled_services.any?
      services = services.select{ |s| enabled_services.include?(s) }
    end

    deployed_services  = resources_fetcher.

    ui.print_warning("Warning", "This command will only check services deployed using k8s")

    ui.print_info("All", services.inspect)

    {}
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)

    false
  end
end