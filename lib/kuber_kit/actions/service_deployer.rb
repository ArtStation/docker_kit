class KuberKit::Actions::ServiceDeployer
  include KuberKit::Import[
    "service_deployer.service_list_resolver",
    "service_deployer.deployer",
    "shell.local_shell",
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
      deployer.deploy(local_shell, service_name.to_sym, :kubernetes)
    end
  end
end