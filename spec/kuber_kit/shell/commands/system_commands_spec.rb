RSpec.describe KuberKit::Shell::Commands::SystemCommands do
  subject { KuberKit::Shell::Commands::SystemCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#kill_process" do
    it do
      expect(shell).to receive(:exec!).with(%Q{kill -9 123}, merge_stderr: true)
      subject.kill_process(shell, "123")
    end
  end

  context "#get_child_pids" do
    it do
      expect(shell).to receive(:exec!).with(%Q{pgrep -P 123}).and_return("122\r\n121")
      expect(subject.get_child_pids(shell, "123")).to eq([122, 121])
    end
  end

  context "#find_pids_by_name" do
    it do
      expect(shell).to receive(:exec!).with("ps auxww | grep 'test' | grep -v 'grep' | awk '{print $2}'").and_return("122\r\n121")
      expect(subject.find_pids_by_name(shell, "test")).to eq([122, 121])
    end
  end
end