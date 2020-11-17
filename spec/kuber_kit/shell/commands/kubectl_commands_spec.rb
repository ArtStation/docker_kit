RSpec.describe KuberKit::Shell::Commands::KubectlCommands do
  subject { KuberKit::Shell::Commands::KubectlCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

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

  context "#patch_deployment" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl patch deployment my_deployment -p "\{\\"spec\\":\\"some_update\\"\}"})
      subject.patch_deployment(shell, "my_deployment", {spec: "some_update"})
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{KUBECONFIG=/path/to/kube.cfg kubectl patch deployment my_deployment -p "\{\\"spec\\":\\"some_update\\"\}"})
      subject.patch_deployment(shell, "my_deployment", {spec: "some_update"}, kubeconfig_path: "/path/to/kube.cfg")
    end
  end

  context "#rolling_restart" do
    it do
      expect(subject).to receive(:patch_deployment).with(shell, "my_deployment", { spec: {
        template: {
          metadata: {
            labels: {
              redeploy: "$(date +%s)"
            }
          }
        }
      }}, kubeconfig_path: "/path/to/kube.cfg")
      subject.rolling_restart(shell, "my_deployment", kubeconfig_path: "/path/to/kube.cfg")
    end
  end
end