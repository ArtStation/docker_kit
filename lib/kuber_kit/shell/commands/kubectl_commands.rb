require 'json'
require 'shellwords'

class KuberKit::Shell::Commands::KubectlCommands
  def apply_file(shell, file_path, kubeconfig_path: nil)
    command_parts = []
    if kubeconfig_path
      command_parts << "KUBECONFIG=#{kubeconfig_path}"
    end

    command_parts << "kubectl apply -f #{file_path}"

    shell.exec!(command_parts.join(" "))
  end

  def exec(shell, pod_name, command, args: nil, kubeconfig_path: nil, interactive: false)
    command_parts = []

    if kubeconfig_path
      command_parts << "KUBECONFIG=#{kubeconfig_path}"
    end

    command_parts << "kubectl exec"

    if args
      command_parts << args
    end

    command_parts << pod_name
    command_parts << "-- #{command}"

    # TODO: investigate how to do it with shell.
    if interactive
      system(command_parts.join(" "))
    else
      shell.exec!(command_parts.join(" "))
    end
  end

  def rolling_restart(shell, deployment_name, kubeconfig_path: nil)
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
    }, kubeconfig_path: kubeconfig_path)
  end

  def patch_deployment(shell, deployment_name, specs, kubeconfig_path: nil)
    command_parts = []
    if kubeconfig_path
      command_parts << "KUBECONFIG=#{kubeconfig_path}"
    end

    specs_json = JSON.dump(specs).gsub('"', '\"')

    command_parts << %Q{kubectl patch deployment #{deployment_name} -p "#{specs_json}"}

    shell.exec!(command_parts.join(" "))
  end
end