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
      shell, "default/auth_app:latest", detached: false, :run_args=>nil, :run_command=>nil
    )
    subject.deploy(shell, service)
  end

  it "deletes previous container if it's enabled for service" do
    expect(subject.docker_commands).to receive(:delete_container).with(shell, "auth-job")
    expect(subject.docker_commands).to receive(:run).with(
      shell, "default/auth_app:latest", detached: false, :run_args=>"-it", :run_command=>nil
    )

    service = service_helper.service(:auth_job, attributes: {
      deployer: {image_name: image.name, delete_if_exists: true, docker_run_args: "-it"}
    })
    subject.deploy(shell, service)
  end
end