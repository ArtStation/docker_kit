require 'json'
require 'shellwords'

class KuberKit::Shell::Commands::KubectlCommands
  include KuberKit::Import[
    "core.artifact_path_resolver"
  ]

  Contract KuberKit::Shell::AbstractShell, Or[String, ArrayOf[String]], KeywordArgs[
    kubeconfig_path: Maybe[Or[
      String, KuberKit::Core::ArtifactPath
    ]],
    namespace:       Maybe[Or[Symbol, String]],
    interactive:     Optional[Bool],
  ] => Any
  def kubectl_run(shell, command_list, kubeconfig_path: nil, namespace: nil, interactive: false)
    command_parts = []

    if kubeconfig_path.is_a?(KuberKit::Core::ArtifactPath)
      kubeconfig_path = artifact_path_resolver.call(kubeconfig_path)
    end

    if kubeconfig_path
      command_parts << "KUBECONFIG=#{kubeconfig_path}"
    end

    command_parts << "kubectl"

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
  
  def apply_file(shell, file_path, kubeconfig_path: nil, namespace: nil)
    kubectl_run(shell, "apply -f #{file_path}", kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def exec(shell, pod_name, command, args: nil, kubeconfig_path: nil, interactive: false, namespace: nil, entrypoint: nil)
    command_parts = []
    command_parts << "exec"

    if args
      command_parts << args
    end
    
    if entrypoint
      command = entrypoint.gsub("$@", command)
    end

    command_parts << pod_name
    command_parts << "-- #{command}"
    kubectl_run(shell, command_parts, kubeconfig_path: kubeconfig_path, interactive: interactive, namespace: namespace)
  end

  def logs(shell, pod_name, args: nil, kubeconfig_path: nil, namespace: nil)
    kubectl_run(shell, ["logs", args, pod_name].compact, kubeconfig_path: kubeconfig_path, interactive: true, namespace: namespace)
  end

  def describe(shell, resource_name, args: nil, kubeconfig_path: nil, namespace: nil)
    kubectl_run(shell, ["describe", args, resource_name].compact, kubeconfig_path: kubeconfig_path, interactive: true, namespace: namespace)
  end

  def get_resources(shell, resource_type, field_selector: nil, jsonpath: ".items[*].metadata.name", kubeconfig_path: nil, namespace: nil)
    command_parts = []
    command_parts << "get #{resource_type}"

    if field_selector
      command_parts << "--field-selector=#{field_selector}"
    end

    if jsonpath 
      command_parts << "-o jsonpath='{#{jsonpath}}'"
    end

    result = kubectl_run(shell, command_parts, kubeconfig_path: kubeconfig_path, namespace: namespace).to_s

    # Hide warnings manually, until appropriate kubectl option will be available
    result = result.split("\n").reject{|n| n.start_with?("Warning:") }.join("\n")

    Array(result.split(" ")).reject(&:empty?)
  end

  def resource_exists?(shell, resource_type, resource_name, kubeconfig_path: nil, namespace: nil)
    result = get_resources(shell, resource_type, 
      field_selector: "metadata.name=#{resource_name}", kubeconfig_path: kubeconfig_path, namespace: namespace
    )
    result.any?
  end

  def delete_resource(shell, resource_type, resource_name, kubeconfig_path: nil, namespace: nil)
    command = %Q{delete #{resource_type} #{resource_name}}

    kubectl_run(shell, command, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def patch_resource(shell, resource_type, resource_name, specs, kubeconfig_path: nil, namespace: nil)
    specs_json = JSON.dump(specs).gsub('"', '\"')

    command = %Q{patch #{resource_type} #{resource_name} -p "#{specs_json}"}

    kubectl_run(shell, command, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def rolling_restart(shell, resource_type, resource_name, kubeconfig_path: nil, namespace: nil)
    patch_resource(shell, resource_type, resource_name, {
      spec: {
        template: {
          metadata: {
            labels: {
              redeploy: "$(date +%s)"
            }
          }
        }
      }
    }, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def rollout_status(shell, resource_type, resource_name, wait: true, kubeconfig_path: nil, namespace: nil)
    command_parts = []
    command_parts << %Q{rollout status #{resource_type} #{resource_name}}
    command_parts << "-w" if wait

    kubectl_run(shell, command_parts, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def set_namespace(shell, namespace, kubeconfig_path: nil)
    command = %Q{config set-context --current --namespace=#{namespace}}

    kubectl_run(shell, command, kubeconfig_path: kubeconfig_path)
  end
end