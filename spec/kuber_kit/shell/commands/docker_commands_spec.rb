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

  context "#run" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker run example_image})
      subject.run(shell, "example_image")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{docker run -d example_image})
      subject.run(shell, "example_image", detached: true)
    end
  end

  context "#push" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker push example_tag})
      subject.push(shell, "example_tag")
    end
  end

  context "#delete_container" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker rm -f example_container})
      subject.delete_container(shell, "example_container")
    end
  end

  context "#container_exists?" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker ps -a -q --filter=\"status=running\" --filter=\"name=my-container\"}).and_return("1234")
      expect(subject.container_exists?(shell, "my-container")).to eq(true)
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