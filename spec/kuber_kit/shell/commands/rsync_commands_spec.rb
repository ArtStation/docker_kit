RSpec.describe KuberKit::Shell::Commands::RsyncCommands do
  subject { KuberKit::Shell::Commands::RsyncCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#rsync" do
    it do
      allow(subject).to receive(:path_is_directory?).and_return(false)

      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from /path/to})
      subject.rsync(shell, "/path/from", "/path/to")
    end

    it do
      allow(subject).to receive(:path_is_directory?).and_return(true)
      
      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from/ /path/to})
      subject.rsync(shell, "/path/from", "/path/to")
    end

    it do
      allow(subject).to receive(:path_is_directory?).and_return(false)
      
      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from /path/to --exclude=*excluded_path*})
      subject.rsync(shell, "/path/from", "/path/to", exclude: "*excluded_path*")
    end

    it do
      allow(subject).to receive(:path_is_directory?).and_return(false)
      
      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from user@example.com:/path/to})
      subject.rsync(shell, "/path/from", "/path/to", target_host: "user@example.com")
    end
  end
end