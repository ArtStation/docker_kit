class KuberKit::Actions::KubectlEnv
  include KuberKit::Import[
    "core.artifact_path_resolver",
    "shell.local_shell",
    "ui"
  ]

  Contract Hash => Any
  def call(options)
    configuration   = KuberKit.current_configuration
    kubeconfig_path = configuration.kubeconfig_path

    if kubeconfig_path.is_a?(KuberKit::Core::ArtifactPath)
      kubeconfig_path = artifact_path_resolver.call(kubeconfig_path)
    end

    ui.print_info("ENV", "export KUBECONFIG=#{kubeconfig_path}")

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end