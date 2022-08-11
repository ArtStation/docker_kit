RSpec.describe KuberKit::Shell::Commands::GitCommands do
  subject { KuberKit::Shell::Commands::GitCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#get_remote_url" do
    it do
      expect(shell).to receive(:exec!).with(%Q{cd /data/myapp && git config --get remote.origin.url})
      subject.get_remote_url(shell, "/data/myapp")
    end
  end

  context "#download_repo" do
    it do
      expect(shell).to receive(:exec!).with(
        %Q{rm -rf /data/myapp && mkdir -p /data/myapp && git clone -b master --depth 1 git@example.com/myapp /data/myapp}
      )
      subject.download_repo(shell, remote_url: "git@example.com/myapp", path: "/data/myapp", branch: "master")
    end
  end

  context "#force_pull_repo" do
    it do
      expect(shell).to receive(:exec!).with(
        %Q{cd /data/myapp && git add . && git reset HEAD --hard && git checkout master && git reset --hard '@{u}' && git pull --force}
      )
      subject.force_pull_repo(shell, path: "/data/myapp", branch: "master")
    end
  end
end