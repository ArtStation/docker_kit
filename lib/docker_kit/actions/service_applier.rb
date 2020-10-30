class DockerKit::Actions::ServiceApplier
  include DockerKit::Import[
    "core.service_store",
    "service_deployer.service_reader",
    "service_deployer.service_list_resolver",
    "shell.local_shell",
    "shell.kubectl_commands",
    "configs",
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
    service_names.each do |service_name|
      apply_service(service_name.to_sym)
    end
  end

  def apply_service(service_name)
    service = service_store.get_service(service_name)
    kubecfg_path = DockerKit.current_configuration.kubecfg_path

    result = service_reader.read(local_shell, service)
    file_path = "#{configs.service_config_dir}/#{service.name}.yml"
    local_shell.write(file_path, result)

    ui.create_task("Applying file: #{file_path}") do |task|
      kubectl_commands.apply_file(local_shell, file_path, kubecfg_path: kubecfg_path)
      task.update_title("Applied file: #{file_path}")
    end
  end
end