RSpec.describe KuberKit::ServiceDeployer::Strategies::KubernetesRunner do
  subject{ KuberKit::ServiceDeployer::Strategies::KubernetesRunner.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.service(:auth_job) }

  it "deletes previous job and applies new one" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_job.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:delete_resource).with(shell, "job", "auth-job", kubeconfig_path: nil, namespace: nil)
    expect(subject.kubectl_commands).to receive(:apply_file).with(shell, "/tmp/kuber_kit/services/auth_job.yml", kubeconfig_path: nil, namespace: nil)
    subject.deploy(shell, service)
  end

  it "doesn't delete job if it's disabled for service" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_job.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to_not receive(:rolling_restart)

    service = service_helper.service(:auth_job, attributes: {deployer_delete_enabled: false})
    subject.deploy(shell, service)
  end

  it "uses custom deployment name if provided" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_job.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:delete_resource).with(shell, "job", "custom-deployment", kubeconfig_path: nil, namespace: nil)
    expect(subject.kubectl_commands).to receive(:apply_file)

    service = service_helper.service(:auth_job, attributes: {deployer_resource_name: "custom-deployment"})
    subject.deploy(shell, service)
  end
end