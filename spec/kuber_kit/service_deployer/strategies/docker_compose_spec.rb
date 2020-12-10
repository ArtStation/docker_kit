RSpec.describe KuberKit::ServiceDeployer::Strategies::DockerCompose do
  subject{ KuberKit::ServiceDeployer::Strategies::DockerCompose.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.service(:auth_app, attributes: {deployment_command_name: "bash"}) }

  it "runs service using docker compose" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.docker_compose_commands).to receive(:run).with(
      shell, "/tmp/kuber_kit/services/auth_app.yml", service: "auth_app", command: "bash"
    )
    subject.deploy(shell, service)
  end
end