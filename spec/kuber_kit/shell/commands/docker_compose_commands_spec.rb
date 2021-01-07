RSpec.describe KuberKit::Shell::Commands::DockerComposeCommands do
  subject { KuberKit::Shell::Commands::DockerComposeCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }
  
  context "#run" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker-compose run -f /path/to/file.yml rspec bash})
      subject.run(shell, "/path/to/file.yml", service: "rspec", command: "bash")
    end

    it do
      expect(shell).to receive(:interactive!).with(%Q{docker-compose run -f /path/to/file.yml rspec bash})
      subject.run(shell, "/path/to/file.yml", service: "rspec", command: "bash", interactive: true)
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{docker-compose run -f /path/to/file.yml -d rspec bash})
      subject.run(shell, "/path/to/file.yml", service: "rspec", command: "bash", detached: true)
    end
  end
end