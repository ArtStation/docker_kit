RSpec.describe KuberKit::Shell::Commands::RsyncCommands do
  subject { KuberKit::Shell::Commands::RsyncCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#rsync" do
    it "doesn't append slash in the end if path is not directory" do
      allow(subject).to receive(:path_is_directory?).and_return(false)

      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from /path/to --delete}, merge_stderr: true)
      subject.rsync(shell, "/path/from", "/path/to")
    end

    it "appends slash in the end if path is directory" do
      allow(subject).to receive(:path_is_directory?).and_return(true)
      
      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from/ /path/to --delete}, merge_stderr: true)
      subject.rsync(shell, "/path/from", "/path/to")
    end

    it "allows excluding files" do
      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from /path/to --exclude=*excluded_path* --delete}, merge_stderr: true)
      subject.rsync(shell, "/path/from", "/path/to", exclude: "*excluded_path*")
    end

    it "allows excluding multiple files" do
      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from /path/to --exclude=*excluded_path* --exclude=another_exclude --delete}, merge_stderr: true)
      subject.rsync(shell, "/path/from", "/path/to", exclude: ["*excluded_path*", "another_exclude"])
    end

    it "allows using remote host" do      
      expect(shell).to receive(:exec!).with(%Q{rsync -a /path/from user@example.com:/path/to --delete}, merge_stderr: true)
      subject.rsync(shell, "/path/from", "/path/to", target_host: "user@example.com")
    end
  end
end