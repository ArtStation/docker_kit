class KuberKit::ServiceDeployer::DeploymentOptionsSelector
  include KuberKit::Import[
    "core.service_store",
    "ui"
  ]

  OPTION_SPECIFIC_SERVICE = "deploy specific service".freeze
  OPTION_ALL_SERVICES     = "deploy all services"

  def call()
    tags = [OPTION_SPECIFIC_SERVICE, OPTION_ALL_SERVICES]
    tags += service_store
      .all_definitions
      .values
      .map(&:to_service_attrs)
      .map(&:tags)
      .flatten
      .uniq
      .sort
      .map(&:to_s)

    selected_tag = ui.prompt("Please select which tag to deploy", tags)

    if selected_tag == OPTION_SPECIFIC_SERVICE
      show_service_selection
    elsif selected_tag == OPTION_ALL_SERVICES
      [["*"], []]
    else
      [[], [selected_tag]]
    end
  end

  def show_service_selection()
    services = service_store
      .all_definitions
      .values
      .map(&:service_name)
      .uniq
      .sort
      .map(&:to_s)

    if services.empty?
      return [[], []]
    end

    selected_service = ui.prompt("Please select which service to deploy", services)
    [[selected_service], []]
  end
end