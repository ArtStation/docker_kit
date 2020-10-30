class KuberKit::Actions::ServiceDeployer
  include KuberKit::Import[
    "service_deployer.service_list_resolver",
    "service_deployer.deployer",
    "shell.local_shell",
    "tools.logger",
    "ui"
  ]

  Contract KeywordArgs[
    services:   Maybe[ArrayOf[String]],
    tags:       Maybe[ArrayOf[String]],
  ] => Any
  def call(services:, tags:)
    service_names = service_list_resolver.resolve(
      services: services || [],
      tags:     tags || []
    )

    task_group = ui.create_task_group

    service_names.each do |service_name|

      logger.info("Started deploying: #{service_name.to_s.green}")
      task_group.add("Deploying #{service_name.to_s.yellow}") do |task|
        deployer.deploy(local_shell, service_name.to_sym)

        task.update_title("Deployed #{service_name.to_s.green}")
        logger.info("Finished deploying: #{service_name.to_s.green}")
      end
    end

    task_group.wait
  end
end