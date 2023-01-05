RSpec.describe KuberKit::Shell::Commands::DockerCommands do
  subject { KuberKit::Shell::Commands::DockerCommands.new }
  let(:shell) { KuberKit::Shell::LocalShell.new }

  context "#build" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker image build /opt/build --rm=true}, merge_stderr: true)
      subject.build(shell, "/opt/build")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{docker image build /opt/build --rm=true -t=example_image}, merge_stderr: true)
      subject.build(shell, "/opt/build", ["-t=example_image"])
    end
  end

  context "#tag" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker tag example_image example_tag}, merge_stderr: true)
      subject.tag(shell, "example_image", "example_tag")
    end
  end

  context "#run" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker run example_image}, merge_stderr: true)
      subject.run(shell, "example_image")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{docker run -d example_image}, merge_stderr: true)
      subject.run(shell, "example_image", detached: true)
    end

    it do
      expect(shell).to receive(:interactive!).with(%Q{docker run -d example_image})
      subject.run(shell, "example_image", detached: true, interactive: true)
    end
  end

  context "#push" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker push example_tag}, merge_stderr: true)
      subject.push(shell, "example_tag")
    end
  end

  context "#delete_container" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker rm -f example_container})
      subject.delete_container(shell, "example_container")
    end
  end

  context "#create_volume" do
    it do
      expect(subject).to receive(:volume_exists?).and_return(false)
      expect(shell).to receive(:exec!).with(%Q{docker volume create test_volume})
      subject.create_volume(shell, "test_volume")
    end

    it do
      expect(subject).to receive(:volume_exists?).and_return(true)
      expect(shell).to_not receive(:exec!)
      subject.create_volume(shell, "test_volume")
    end
  end

  context "#create_network" do
    it do
      expect(subject).to receive(:network_exists?).and_return(false)
      expect(shell).to receive(:exec!).with(%Q{docker network create test_network})
      subject.create_network(shell, "test_network")
    end

    it do
      expect(subject).to receive(:network_exists?).and_return(true)
      expect(shell).to_not receive(:exec!)
      subject.create_network(shell, "test_network")
    end
  end

  context "#container_exists?" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker ps -a -q --filter=\"name=^/my-container$\"}).and_return("1234")
      expect(subject.container_exists?(shell, "my-container")).to eq(true)
    end
  end

  context "#get_containers" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker ps -a -q --filter=\"status=running\" --filter=\"name=^/example_container$\"})
      subject.get_containers(shell, "example_container", status: "running")
    end

    it do
      expect(shell).to receive(:exec!).with(%Q{docker ps -a -q --filter=\"health=healthy\" --filter=\"name=^/example_container$\"})
      subject.get_containers(shell, "example_container", only_healthy: true)
    end
  end

  context "#network_exists?" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker network ls --filter=\"name=my-network\" --format \"\{\{.Name\}\}\"}).and_return("1234")
      expect(subject.network_exists?(shell, "my-network")).to eq(true)
    end
  end

  context "#volume_exists?" do
    it do
      expect(shell).to receive(:exec!).with(%Q{docker volume ls --filter=\"name=my-volume\" --format \"\{\{.Name\}\}\"}).and_return("1234")
      expect(subject.volume_exists?(shell, "my-volume")).to eq(true)
    end
  end
end