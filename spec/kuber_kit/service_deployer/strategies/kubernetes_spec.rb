RSpec.describe KuberKit::ServiceDeployer::Strategies::Kubernetes do
  subject{ KuberKit::ServiceDeployer::Strategies::Kubernetes.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.service(:auth_app) }

  it "applies config and restarts deployment" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file).with(shell, "/tmp/kuber_kit/services/auth_app.yml", kubeconfig_path: nil)
    expect(subject.kubectl_commands).to receive(:rolling_restart).with(shell, "auth-app", kubeconfig_path: nil)
    subject.deploy(shell, service)
  end

  it "doesn't restart deployment if it's disabled for service" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to_not receive(:rolling_restart)

    service = service_helper.service(:auth_app, attributes: {deployment_restart_enabled: false})
    subject.deploy(shell, service)
  end

  it "uses custom deployment name if provided" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to receive(:rolling_restart).with(shell, "custom-deployment", kubeconfig_path: nil)

    service = service_helper.service(:auth_app, attributes: {deployment_restart_name: "custom-deployment"})
    subject.deploy(shell, service)
  end
end