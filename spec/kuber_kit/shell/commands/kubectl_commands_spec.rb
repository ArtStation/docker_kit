RSpec.describe KuberKit::Shell::Commands::KubectlCommands do
  subject { KuberKit::Shell::Commands::KubectlCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }
  
  context "#kubectl_run" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl some_command})
      subject.kubectl_run(shell, "some_command")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl -n community some_command})
      subject.kubectl_run(shell, "some_command", namespace: "community")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{KUBECONFIG=/path/to/kube.cfg kubectl some_command})
      subject.kubectl_run(shell, "some_command", kubeconfig_path: "/path/to/kube.cfg")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl some_command some_argument})
      subject.kubectl_run(shell, ["some_command", "some_argument"])
    end
  end

  context "#apply_file" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl apply -f /file/to/apply.yml})
      subject.apply_file(shell, "/file/to/apply.yml")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{KUBECONFIG=/path/to/kube.cfg kubectl apply -f /file/to/apply.yml})
      subject.apply_file(shell, "/file/to/apply.yml", kubeconfig_path: "/path/to/kube.cfg")
    end
  end

  context "#exec" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl exec my-pod -- bash})
      subject.exec(shell, "my-pod", "bash")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl exec -it my-pod -- bash})
      subject.exec(shell, "my-pod", "bash", args: "-it")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{KUBECONFIG=/path/to/kube.cfg kubectl exec my-pod -- bash})
      subject.exec(shell, "my-pod", "bash", kubeconfig_path: "/path/to/kube.cfg")
    end
  end

  context "#logs" do
    it do
      expect(shell).to receive(:interactive!).with(%Q{kubectl logs my-pod})
      subject.logs(shell, "my-pod")
    end

    it do
      expect(shell).to receive(:interactive!).with(%Q{kubectl logs -it my-pod})
      subject.logs(shell, "my-pod", args: "-it")
    end
  end

  context "#describe" do
    it do
      expect(shell).to receive(:interactive!).with(%Q{kubectl describe pod/my-pod})
      subject.describe(shell, "pod/my-pod")
    end

    it do
      expect(shell).to receive(:interactive!).with(%Q{kubectl describe -it pod/my-pod})
      subject.describe(shell, "pod/my-pod", args: "-it")
    end
  end

  context "#patch_resource" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl patch deployment my_deployment -p "\{\\"spec\\":\\"some_update\\"\}"})
      subject.patch_resource(shell, "deployment", "my_deployment", {spec: "some_update"})
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{KUBECONFIG=/path/to/kube.cfg kubectl patch job my_job -p "\{\\"spec\\":\\"some_update\\"\}"})
      subject.patch_resource(shell, "job", "my_job", {spec: "some_update"}, kubeconfig_path: "/path/to/kube.cfg")
    end
  end

  context "#delete_resource" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl delete job my-job})
      subject.delete_resource(shell, "job", "my-job")
    end
  end

  context "#get_resources" do
    it do
      expect(shell).to receive(:exec!).with("kubectl get job --field-selector=metadata.name=my-job -o jsonpath='{.items[*].metadata.name}'")
      subject.get_resources(shell, "job", field_selector: "metadata.name=my-job")
    end
  end

  context "#resource_exists?" do
    it do
      expect(shell).to receive(:exec!).with("kubectl get job --field-selector=metadata.name=my-job -o jsonpath='{.items[*].metadata.name}'").and_return("my-job")
      expect(subject.resource_exists?(shell, "job", "my-job")).to eq(true)
    end
  end

  context "#rolling_restart" do
    it do
      expect(subject).to receive(:patch_resource).with(shell, "deployment", "my_deployment", { spec: {
        template: {
          metadata: {
            labels: {
              redeploy: "$(date +%s)"
            }
          }
        }
      }}, kubeconfig_path: "/path/to/kube.cfg", namespace: "test")
      subject.rolling_restart(shell, "deployment", "my_deployment", kubeconfig_path: "/path/to/kube.cfg", namespace: "test")
    end
  end
end