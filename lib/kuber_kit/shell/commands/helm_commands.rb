class KuberKit::Shell::Commands::HelmCommands
  Contract KuberKit::Shell::AbstractShell, Or[String, ArrayOf[String]], KeywordArgs[
    kubeconfig_path: Maybe[Or[
      String, KuberKit::Core::ArtifactPath
    ]],
    namespace:              Maybe[Or[Symbol, String]],
    interactive:            Optional[Bool],
  ] => Any
  def helm_run(shell, command_list, kubeconfig_path: nil, namespace: nil, interactive: false)
    command_parts = []

    if kubeconfig_path.is_a?(KuberKit::Core::ArtifactPath)
      kubeconfig_path = artifact_path_resolver.call(kubeconfig_path)
    end

    if kubeconfig_path
      command_parts << "KUBECONFIG=#{kubeconfig_path}"
    end

    command_parts << "helm"

    if namespace
      command_parts << "-n #{namespace}"
    end

    command_parts += Array(command_list).compact

    if interactive
      shell.interactive!(command_parts.join(" "))
    else
      shell.exec!(command_parts.join(" "))
    end
  end

  def install(shell, release_name, chart_path, kubeconfig_path: nil, namespace: nil)
    helm_run(shell, "install #{release_name} #{chart_path}", kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def upgrade(shell, release_name, chart_path, kubeconfig_path: nil, namespace: nil)
    helm_run(shell, "upgrade #{release_name} #{chart_path} --install", kubeconfig_path: kubeconfig_path, namespace: namespace)
  end
end