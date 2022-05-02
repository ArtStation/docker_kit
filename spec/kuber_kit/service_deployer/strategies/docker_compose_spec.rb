RSpec.describe KuberKit::ServiceDeployer::Strategies::DockerCompose do
  subject{ KuberKit::ServiceDeployer::Strategies::DockerCompose.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.service(:auth_app) }
  let(:service_config_path) { File.join("~", ".kuber_kit/services/auth_app.yml") }

  it "runs service using docker compose" do
    expect(shell).to receive(:write).with(service_config_path, /apiVersion: v1/)
    expect(subject.docker_compose_commands).to receive(:run).with(
      shell, service_config_path, service: "auth_app", args: nil,
      command: nil, interactive: true, detached: false
    )
    subject.deploy(shell, service)
  end

  it "runs uses custom args: nil,  if provided" do
    expect(shell).to receive(:write).with(service_config_path, /apiVersion: v1/)
    expect(subject.docker_compose_commands).to receive(:run).with(
      shell, service_config_path, service: "auth_app", args: nil,
      command: "sh", interactive: true, detached: false
    )

    service = service_helper.service(:auth_app, attributes: {deployer: {command_name: "sh"}})
    subject.deploy(shell, service)
  end

  it "raises error if unknown strategy option is provided" do
    service = service_helper.service(:auth_app, attributes: {deployer: {unknown: "sh"}})
    expect{ subject.deploy(shell, service) }.to raise_error(KuberKit::Error, /Unknow options for deploy strategy/)
  end
end