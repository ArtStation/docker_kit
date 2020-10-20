RSpec.describe Indocker::Shell::RsyncCommands do
  subject { Indocker::Shell::RsyncCommands.new }
  let(:shell) { Indocker::Shell::LocalShell.new }

  context "#rsync" do
    it do
      allow(subject).to receive(:path_is_directory?).and_return(false)

      expect(shell).to receive(:exec!).with(%Q{rsync /path/from /path/to})
      subject.rsync(shell, "/path/from", "/path/to")
    end

    it do
      allow(subject).to receive(:path_is_directory?).and_return(true)
      
      expect(shell).to receive(:exec!).with(%Q{rsync /path/from/ /path/to})
      subject.rsync(shell, "/path/from", "/path/to")
    end

    it do
      allow(subject).to receive(:path_is_directory?).and_return(false)
      
      expect(shell).to receive(:exec!).with(%Q{rsync /path/from /path/to --exclude=*excluded_path*})
      subject.rsync(shell, "/path/from", "/path/to", exclude: "*excluded_path*")
    end
  end
end