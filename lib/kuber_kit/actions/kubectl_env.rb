class KuberKit::Actions::KubectlEnv
  include KuberKit::Import[
    "shell.local_shell",
    "ui"
  ]

  Contract Hash => Any
  def call(options)
    configuration   = KuberKit.current_configuration
    kubeconfig_path = configuration.kubeconfig_path
    ui.print_info("ENV", "export KUBECONFIG=#{kubeconfig_path}")

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end