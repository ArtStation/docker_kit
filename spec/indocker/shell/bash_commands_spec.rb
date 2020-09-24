RSpec.describe Indocker::Shell::BashCommands do
  subject(:bash_commands) { Indocker::Shell::BashCommands.new }
  let(:shell) { Indocker::Shell::LocalShell.new }

  context "#rm" do
    it do
      expect(shell).to receive(:exec!).with(%Q{rm "/test"})
      bash_commands.rm(shell, "/test")
    end
  end

  context "#rm_rf" do
    it do
      expect(shell).to receive(:exec!).with(%Q{rm -rf "/test"})
      bash_commands.rm_rf(shell, "/test")
    end
  end

  context "#cp" do
    it do
      expect(shell).to receive(:exec!).with(%Q{cp "/test" "/test2"})
      bash_commands.cp(shell, "/test", "/test2")
    end
  end

  context "#cp_r" do
    it do
      expect(shell).to receive(:exec!).with(%Q{cp -r "/test" "/test2"})
      bash_commands.cp_r(shell, "/test", "/test2")
    end
  end

  context "#mkdir" do
    it do
      expect(shell).to receive(:exec!).with(%Q{mkdir "/test"})
      bash_commands.mkdir(shell, "/test")
    end
  end

  context "#mkdir_p" do
    it do
      expect(shell).to receive(:exec!).with(%Q{mkdir -p "/test"})
      bash_commands.mkdir_p(shell, "/test")
    end
  end
end