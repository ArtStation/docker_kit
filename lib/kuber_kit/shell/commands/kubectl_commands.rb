require 'json'
require 'shellwords'

class KuberKit::Shell::Commands::KubectlCommands
  def kubectl_run(shell, command_list, kubeconfig_path: nil, namespace: nil, interactive: false)
    command_parts = []
    if kubeconfig_path
      command_parts << "KUBECONFIG=#{kubeconfig_path}"
    end

    command_parts << "kubectl"

    if namespace
      command_parts << "-n #{namespace}"
    end

    command_parts += Array(command_list)

    # TODO: investigate how to do it with shell.
    if interactive
      system(command_parts.join(" "))
    else
      shell.exec!(command_parts.join(" "))
    end
  end
  
  def apply_file(shell, file_path, kubeconfig_path: nil, namespace: nil)
    kubectl_run(shell, "apply -f #{file_path}", kubeconfig_path: kubeconfig_path, namespace: namespace)
  end

  def exec(shell, pod_name, command, args: nil, kubeconfig_path: nil, interactive: false, namespace: nil)
    command_parts = []
    command_parts << "exec"

    if args
      command_parts << args
    end

    command_parts << pod_name
    command_parts << "-- #{command}"
    kubectl_run(shell, command_parts, kubeconfig_path: kubeconfig_path, interactive: interactive, namespace: namespace)
  end

  def rolling_restart(shell, deployment_name, kubeconfig_path: nil, namespace: namespace)
    patch_deployment(shell, deployment_name, {
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

  def patch_deployment(shell, deployment_name, specs, kubeconfig_path: nil, namespace: nil)
    specs_json = JSON.dump(specs).gsub('"', '\"')

    command = %Q{patch deployment #{deployment_name} -p "#{specs_json}"}

    kubectl_run(shell, command, kubeconfig_path: kubeconfig_path, namespace: namespace)
  end
end