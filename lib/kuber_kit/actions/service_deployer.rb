class KuberKit::Actions::ServiceDeployer
  include KuberKit::Import[
    "actions.image_compiler",
    "service_deployer.service_list_resolver",
    "core.service_store",
    "shell.local_shell",
    "tools.logger",
    "ui",
    service_deployer: "service_deployer.action_handler",
  ]

  Contract KeywordArgs[
    services:   Maybe[ArrayOf[String]],
    tags:       Maybe[ArrayOf[String]],
  ] => Any
  def call(services:, tags:)
    if services.empty? && tags.empty?
      services, tags = show_tags_selection
    end

    service_names = service_list_resolver.resolve(
      services: services || [],
      tags:     tags || []
    )

    unless service_names.any?
      ui.print_warning "WARNING", "No service found with given options, nothing will be deployed."
    end

    services = service_names.map do |service_name|
      service_store.get_service(service_name.to_sym)
    end

    images_names = services.map(&:images).flatten.uniq

    compile_images(images_names)
    deploy_services(service_names)

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)

    false
  end

  def deploy_services(service_names)
    task_group = ui.create_task_group

    service_names.each do |service_name|

      logger.info("Started deploying: #{service_name.to_s.green}")
      task_group.add("Deploying #{service_name.to_s.yellow}") do |task|
        service_deployer.call(local_shell, service_name.to_sym)

        task.update_title("Deployed #{service_name.to_s.green}")
        logger.info("Finished deploying: #{service_name.to_s.green}")
      end
    end

    task_group.wait
  end

  def compile_images(images_names)
    image_compiler.call(images_names, {}) if images_names.any?
  end

  def show_tags_selection()
    specific_service_option = "deploy specific service"

    tags = [specific_service_option]
    tags += service_store
      .all_definitions
      .values
      .map(&:to_service_attrs)
      .map(&:tags)
      .flatten
      .uniq
      .sort
      .map(&:to_s)

    ui.prompt("Please select which tag to deploy", tags) do |selected_tag|
      if selected_tag == specific_service_option
        show_service_selection
      else
        return [[], [selected_tag]]
      end
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

    ui.prompt("Please select which service to deploy", services) do |selected_service|
      return [[selected_service], []]
    end
  end
end