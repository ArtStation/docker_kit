RSpec.describe KuberKit::Shell::KubectlCommands do
  subject { KuberKit::Shell::KubectlCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#apply_file" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl apply -f /file/to/apply.yml})
      subject.apply_file(shell, "/file/to/apply.yml")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{KUBECFG=/path/to/kube.cfg kubectl apply -f /file/to/apply.yml})
      subject.apply_file(shell, "/file/to/apply.yml", kubecfg_path: "/path/to/kube.cfg")
    end
  end

  context "#patch_deployment" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kubectl patch deployment my_deployment -p "\{\\"spec\\":\\"some_update\\"\}"})
      subject.patch_deployment(shell, "my_deployment", {spec: "some_update"})
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{KUBECFG=/path/to/kube.cfg kubectl patch deployment my_deployment -p "\{\\"spec\\":\\"some_update\\"\}"})
      subject.patch_deployment(shell, "my_deployment", {spec: "some_update"}, kubecfg_path: "/path/to/kube.cfg")
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
      }}, kubecfg_path: "/path/to/kube.cfg")
      subject.rolling_restart(shell, "my_deployment", kubecfg_path: "/path/to/kube.cfg")
    end
  end
end