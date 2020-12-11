RSpec.describe KuberKit::Shell::Commands::DockerCommands do
  subject { KuberKit::Shell::Commands::DockerCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#build" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker build /opt/build --rm=true})
      subject.build(shell, "/opt/build")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{docker build /opt/build --rm=true -t=example_image})
      subject.build(shell, "/opt/build", ["-t=example_image"])
    end
  end

  context "#tag" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker tag example_image example_tag})
      subject.tag(shell, "example_image", "example_tag")
    end
  end

  context "#push" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker push example_tag})
      subject.push(shell, "example_tag")
    end
  end

  context "#get_container_id" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker ps -a -q --filter=\"status=running\" --filter=\"name=example_container\"})
      subject.get_container_id(shell, "example_container")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{docker ps -a -q --filter=\"health=healthy\" --filter=\"status=running\" --filter=\"name=example_container\"})
      subject.get_container_id(shell, "example_container", only_healthy: true)
    end
  end
end