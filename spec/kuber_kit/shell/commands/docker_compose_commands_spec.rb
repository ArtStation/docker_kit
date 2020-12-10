RSpec.describe KuberKit::Shell::Commands::DockerComposeCommands do
  subject { KuberKit::Shell::Commands::DockerComposeCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }
  
  context "#run" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker-compose -f /path/to/file.yml run rspec bash})
      subject.run(shell, "/path/to/file.yml", service: "rspec", command: "bash")
    end
  end
end