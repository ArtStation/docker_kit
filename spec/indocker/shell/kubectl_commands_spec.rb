RSpec.describe Indocker::Shell::KubectlCommands do
  subject { Indocker::Shell::KubectlCommands.new }
  let(:shell) { Indocker::Shell::LocalShell.new }

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
end