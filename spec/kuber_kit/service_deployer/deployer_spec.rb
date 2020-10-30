RSpec.describe KuberKit::ServiceDeployer::Deployer do
  subject{ KuberKit::ServiceDeployer::Deployer.new }

  let(:shell) { test_helper.shell }
  let(:shell) { test_helper.shell }

  before do
    service_helper.register_service(:auth_app)
  end

  it "prints content of service config" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file).with(shell, "/tmp/kuber_kit/services/auth_app.yml", kubecfg_path: nil)
    subject.deploy(shell, :auth_app)
  end
end