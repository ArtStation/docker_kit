RSpec.describe KuberKit::ServiceDeployer::Strategies::Docker do
  subject{ KuberKit::ServiceDeployer::Strategies::Docker.new }

  let(:shell) { test_helper.shell }
  let(:image) { test_helper.image(:auth_app) }
  let(:service) { service_helper.service(:auth_app, attributes: {deployer: {image_name: image.name}}) }

  before do
    expect(subject.image_store).to receive(:get_image).with(image.name).and_return(image)
  end

  it "runs docker container" do
    expect(subject.docker_commands).to receive(:run).with(
      shell, "default/auth_app:latest", detached: false, args: ["--name auth-app"], command: "bash"
    )
    subject.deploy(shell, service)
  end

  it "creates volume and sets volume option for named volume" do
    service = service_helper.service(:auth_app, attributes: {
      deployer: {image_name: image.name, volumes: ["test_volume:/opt"]}
    })
    expect(subject.docker_commands).to receive(:create_volume).with(shell, "test_volume")
    expect(subject.docker_commands).to receive(:run).with(
      shell, "default/auth_app:latest", detached: false, args: ["--name auth-app", "--volume test_volume:/opt"], command: "bash"
    )
    subject.deploy(shell, service)
  end

  it "sets volume option for local volume" do
    service = service_helper.service(:auth_app, attributes: {
      deployer: {image_name: image.name, volumes: ["/opt:/opt"]}
    })
    expect(subject.docker_commands).to_not receive(:create_volume)
    expect(subject.docker_commands).to receive(:run).with(
      shell, "default/auth_app:latest", detached: false, args: ["--name auth-app", "--volume /opt:/opt"], command: "bash"
    )
    subject.deploy(shell, service)
  end

  it "creates network and sets network option" do
    service = service_helper.service(:auth_app, attributes: {
      deployer: {image_name: image.name, networks: [:test_network]}
    })
    expect(subject.docker_commands).to receive(:create_network).with(shell, :test_network)
    expect(subject.docker_commands).to receive(:run).with(
      shell, "default/auth_app:latest", detached: false, args: ["--name auth-app", "--network test_network"], command: "bash"
    )
    subject.deploy(shell, service)
  end

  it "deletes previous container if it's enabled for service" do
    expect(subject.docker_commands).to receive(:delete_container).with(shell, "auth-job")
    expect(subject.docker_commands).to receive(:run).with(
      shell, "default/auth_app:latest", detached: false, args: ["-it", "--name auth-job"], command: "bash"
    )

    service = service_helper.service(:auth_job, attributes: {
      deployer: {image_name: image.name, delete_if_exists: true, custom_args: "-it"}
    })
    subject.deploy(shell, service)
  end
end