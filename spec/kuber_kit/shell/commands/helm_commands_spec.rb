RSpec.describe KuberKit::Shell::Commands::HelmCommands do
  subject { KuberKit::Shell::Commands::HelmCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#install" do
    it do
      expect(shell).to receive(:exec!).with(%Q{helm install learning-app /path/to/chart})
      subject.install(shell, "learning-app", "/path/to/chart")
    end
  end

  context "#upgrade" do
    it do
      expect(shell).to receive(:exec!).with(%Q{helm upgrade learning-app /path/to/chart --install --wait})
      subject.upgrade(shell, "learning-app", "/path/to/chart")
    end
    
    it do
      expect(shell).to receive(:exec!).with(%Q{KUBECONFIG=/path/to/kube.cfg helm upgrade learning-app /path/to/chart --install --wait})
      subject.upgrade(shell, "learning-app", "/path/to/chart", kubeconfig_path: "/path/to/kube.cfg")
    end
  end
end