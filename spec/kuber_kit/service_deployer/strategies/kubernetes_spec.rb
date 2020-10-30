RSpec.describe KuberKit::ServiceDeployer::Strategies::Kubernetes do
  subject{ KuberKit::ServiceDeployer::Strategies::Kubernetes.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.register_service(:auth_app) }

  it "prints content of service config" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file).with(shell, "/tmp/kuber_kit/services/auth_app.yml", kubeconfig_path: nil)
    subject.restart(shell, service)
  end
end