class KuberKit::ServiceDeployer::Strategies::Helm < KuberKit::ServiceDeployer::Strategies::Abstract
  include KuberKit::Import[
    "shell.helm_commands",
    "tools.helm_package_generator",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Service => Any
  def deploy(shell, service)
    chart_root_path = helm_package_generator.call(shell, service)

    kubeconfig_path = KuberKit.current_configuration.kubeconfig_path
    namespace       = KuberKit.current_configuration.deployer_namespace

    upgrade_result = helm_commands.upgrade(shell, service.uri, chart_root_path, kubeconfig_path: kubeconfig_path, namespace: namespace)
    
    upgrade_result
  end
end