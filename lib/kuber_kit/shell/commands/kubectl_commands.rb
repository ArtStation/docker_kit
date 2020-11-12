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