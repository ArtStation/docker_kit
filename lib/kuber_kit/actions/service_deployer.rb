class KuberKit::Actions::ServiceDeployer
  include KuberKit::Import[
    "actions.image_compiler",
    "service_deployer.service_list_resolver",
    "service_deployer.service_dependency_resolver",
    "service_deployer.deployment_options_selector",
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
    skip_dependencies:    Maybe[Bool],
    require_confirmation: Maybe[Bool],
  ] => Any
  def call(services:, tags:, skip_services: nil, skip_compile: false, skip_dependencies: false, require_confirmation: false)
    deployment_result     = KuberKit::Actions::ActionResult.new()
    current_configuration = KuberKit.current_configuration

    if services.empty? && tags.empty?
      services, tags = deployment_options_selector.call()
    end

    default_services  = current_configuration.default_services.map(&:to_s)
    disabled_services = current_configuration.disabled_services.map(&:to_s)
    disabled_services += skip_services if skip_services

    service_names = service_list_resolver.resolve(
      services:         services || [],
      tags:             tags || [],
      enabled_services:   current_configuration.enabled_services.map(&:to_s),
      disabled_services:  disabled_services,
      default_services:   default_services
    ).map(&:to_sym)

    # Return the list of services with all dependencies.
    if skip_dependencies
      all_service_names = service_names
    else
      all_service_names = service_dependency_resolver.get_all(service_names)
    end

    unless all_service_names.any?
      ui.print_warning "ServiceDeployer", "No service found with given options, nothing will be deployed."
      return false
    end

    unless allow_deployment?(require_confirmation: require_confirmation, service_names: all_service_names)
      return false
    end

    # Compile images for all services and dependencies
    images_names = get_image_names(service_names: all_service_names)
    unless skip_compile
      compilation_result = compile_images(images_names)

      return false unless compilation_result && compilation_result.succeeded?
    end

    if skip_dependencies
      service_names.each_slice(configs.deploy_simultaneous_limit) do |batch_service_names|
        ui.print_debug("ServiceDeployer", "Scheduling to compile: #{batch_service_names.inspect}. Limit: #{configs.deploy_simultaneous_limit}")

        if deployment_result.succeeded?
          deploy_simultaneously(batch_service_names, deployment_result)
        end
      end
    else
      service_dependency_resolver.each_with_deps(service_names) do |dep_service_names|
        ui.print_debug("ServiceDeployer", "Scheduling to compile: #{dep_service_names.inspect}. Limit: #{configs.deploy_simultaneous_limit}")

        if deployment_result.succeeded?
          deploy_simultaneously(dep_service_names, deployment_result)
        end
      end
    end

    deployment_result
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)

    deployment_result.failed!(e.message)
    
    false
  rescue Interrupt => e
    process_cleaner.clean

    false
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

    def get_image_names(service_names:)
      services = service_names.map do |service_name|
        service_store.get_service(service_name.to_sym)
      end
  
      services.map(&:images).flatten.uniq
    end

    def allow_deployment?(require_confirmation:, service_names:)
      services_list = service_names.map(&:to_s).map(&:yellow).join(", ")
      ui.print_info "ServiceDeployer", "The following services will be deployed: #{services_list}"

      unless require_confirmation
        return true
      end

      result = ui.prompt("Please confirm to continue deployment", ["confirm".green, "cancel".red])
      return ["confirm".green, "confirm", "yes"].include?(result)
    end
end