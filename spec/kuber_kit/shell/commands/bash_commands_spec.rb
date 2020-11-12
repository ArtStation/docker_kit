RSpec.describe KuberKit::Shell::Commands::BashCommands do
  subject { KuberKit::Shell::Commands::BashCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#rm" do
    it do
      expect(shell).to receive(:exec!).with(%Q{rm "/test"})
      subject.rm(shell, "/test")
    end
  end

  context "#rm_rf" do
    it do
      expect(shell).to receive(:exec!).with(%Q{rm -rf "/test"})
      subject.rm_rf(shell, "/test")
    end
  end

  context "#cp" do
    it do
      expect(shell).to receive(:exec!).with(%Q{cp "/test" "/test2"})
      subject.cp(shell, "/test", "/test2")
    end
  end

  context "#cp_r" do
    it do
      expect(shell).to receive(:exec!).with(%Q{cp -r "/test" "/test2"})
      subject.cp_r(shell, "/test", "/test2")
    end
  end

  context "#mkdir" do
    it do
      expect(shell).to receive(:exec!).with(%Q{mkdir "/test"})
      subject.mkdir(shell, "/test")
    end
  end

  context "#mkdir_p" do
    it do
      expect(shell).to receive(:exec!).with(%Q{mkdir -p "/test"})
      subject.mkdir_p(shell, "/test")
    end
  end
end