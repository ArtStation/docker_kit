class KuberKit::Actions::ServiceChecker
  include KuberKit::Import[
    "kubernetes.resources_fetcher",
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

    deployments = resources_fetcher.call("deployments")

    missing_services = services.select{ |s| !deployments.include?(s.gsub("_", "-")) }

    ui.print_warning("Warning", "This command will only check services deployed using k8s")

    ui.print_info("Missing", missing_services.inspect)

    {}
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)

    false
  end
end