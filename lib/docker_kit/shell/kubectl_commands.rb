class DockerKit::Shell::KubectlCommands
  def apply_file(shell, file_path, kubecfg_path: nil)
    command_parts = []
    if kubecfg_path
      command_parts << "KUBECFG=#{kubecfg_path}"
    end

    command_parts << "kubectl apply -f #{file_path}"

    shell.exec!(command_parts.join(" "))
  end
end