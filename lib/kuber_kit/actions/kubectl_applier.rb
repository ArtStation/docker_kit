class KuberKit::Actions::KubectlApplier
  include KuberKit::Import[
    "shell.kubectl_commands",
    "shell.local_shell",
    "ui"
  ]

  Contract String, Hash => Any
  def call(file_path, options)
    kubeconfig_path  = KuberKit.current_configuration.kubeconfig_path
    deployer_namespace = KuberKit.current_configuration.deployer_namespace
    ui.create_task("Applying file: #{file_path}") do |task|
      kubectl_commands.apply_file(local_shell, file_path, kubeconfig_path: kubeconfig_path, namespace: deployer_namespace)
      task.update_title("Applied file: #{file_path}")
    end

    true
  rescue KuberKit::Error => e
    ui.print_error("Error", e.message)
    
    false
  end
end