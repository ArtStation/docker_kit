class KuberKit::Actions::ServiceDeployer
  include KuberKit::Import[
    "actions.image_compiler",
    "service_deployer.service_list_resolver",
    "service_deployer.service_dependency_resolver",
    "core.service_store",
    "shell.local_shell",
    "tools.process_cleaner",
    "configs",
    "ui",
    service_deployer: "service_deployer.action_handler",
  ]

  Contract KeywordArgs[
    services:             Maybe[ArrayOf[String]],
    tags:                 Maybe[ArrayOf[String]],
    skip_services:        Maybe[ArrayOf[String]],
    skip_compile:         Maybe[Bool],
    require_confirmation: Maybe[Bool],
  ] => Any
  def call(services:, tags:, skip_services: nil, skip_compile: false, require_confirmation: false)
    deployment_result     = KuberKit::Actions::ActionResult.new()
    current_configuration = KuberKit.current_configuration

    if services.empty? && tags.empty?
      services, tags = show_tags_selection
    end


    disabled_services = current_configuration.disabled_services.map(&:to_s)
    disabled_services += skip_services if skip_services

    service_names = service_list_resolver.resolve(
      services:         services || [],
      tags:             tags || [],
      enabled_services:   current_configuration.enabled_services.map(&:to_s),
      disabled_services:  disabled_services
    ).map(&:to_sym)

    # Return the list of services with all dependencies.
    all_service_names = service_dependency_resolver.get_all(service_names)

    unless all_service_names.any?
      ui.print_warning "ServiceDeployer", "No service found with given options, nothing will be deployed."
      return false
    end

    services_list = all_service_names.map(&:to_s).map(&:yellow).join(", ")
    ui.print_info "ServiceDeployer", "The following services will be deployed: #{services_list}"

    if require_confirmation
      result = ui.prompt("Please confirm to continue deployment", ["confirm".green, "cancel".red])
      return false unless ["confirm".green, "confirm", "yes"].include?(result)
    end

    services = all_service_names.map do |service_name|
      service_store.get_service(service_name.to_sym)
    end

    images_names = services.map(&:images).flatten.uniq

    unless skip_compile
      compilation_result = compile_images(images_names)

      return false unless compilation_result && compilation_result.succeeded?
    end

    service_dependency_resolver.each_with_deps(service_names) do |dep_service_names|
      ui.print_debug("ServiceDeployer", "Scheduling to compile: #{dep_service_names.inspect}. Limit: #{configs.deploy_simultaneous_limit}")

      if deployment_result.succeeded?
        deploy_simultaneously(dep_service_names, deployment_result)
      end
    end

    deployment_result
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)

    compilation_result.failed!(e.message)

    false
  rescue Interrupt => e
    process_cleaner.clean
  end

  private
    def deploy_simultaneously(service_names, deployment_result)
      task_group = ui.create_task_group

      service_names.each do |service_name|

        ui.print_debug("ServiceDeployer", "Started deploying: #{service_name.to_s.green}")
        task_group.add("Deploying #{service_name.to_s.yellow}") do |task|
          deployment_result.start_task(service_name)
          service_result = service_deployer.call(local_shell, service_name.to_sym)
          deployment_result.finish_task(service_name, service_result)

          task.update_title("Deployed #{service_name.to_s.green}")
          ui.print_debug("ServiceDeployer", "Finished deploying: #{service_name.to_s.green}")
        end
      end

      task_group.wait
    end

    def compile_images(images_names)
      return KuberKit::Actions::ActionResult.new if images_names.empty?
      image_compiler.call(images_names, {})
    end

    def show_tags_selection()
      specific_service_option = "deploy specific service"
      all_services_option     = "deploy all services"

      tags = [specific_service_option, all_services_option]
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

      if selected_tag == specific_service_option
        show_service_selection
      elsif selected_tag == all_services_option
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