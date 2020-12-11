RSpec.describe KuberKit::ServiceDeployer::Strategies::Kubernetes do
  subject{ KuberKit::ServiceDeployer::Strategies::Kubernetes.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.service(:auth_app) }

  it "applies kubernetes config" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file).with(
      shell, "/tmp/kuber_kit/services/auth_app.yml", kubeconfig_path: nil, namespace: nil
    )
    subject.deploy(shell, service)
  end

  it "restarts service if it exists" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:resource_exists?).and_return(true)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to receive(:rolling_restart).with(
      shell, "deployment", "auth-app", kubeconfig_path: nil, namespace: nil
    )

    subject.deploy(shell, service)
  end

  it "doesn't restart deployment if it's disabled for service" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to_not receive(:rolling_restart)

    service = service_helper.service(:auth_app, attributes: {deployer: {restart_if_exists: false}})
    subject.deploy(shell, service)
  end

  it "deletes previous deployment if it's enabled for service" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_job.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:delete_resource).with(shell, "job", "auth-job", kubeconfig_path: nil, namespace: nil)
    expect(subject.kubectl_commands).to receive(:apply_file).with(
      shell, "/tmp/kuber_kit/services/auth_job.yml", kubeconfig_path: nil, namespace: nil
    )

    service = service_helper.service(:auth_job, attributes: {deployer: {resource_type: "job", delete_if_exists: true}})
    subject.deploy(shell, service)
  end

  it "uses custom deployment name if provided" do
    expect(shell).to receive(:write).with("/tmp/kuber_kit/services/auth_app.yml", /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to receive(:rolling_restart).with(
      shell, "deployment", "custom-deployment", kubeconfig_path: nil, namespace: nil
    )

    service = service_helper.service(:auth_app, attributes: {deployer: {resource_name: "custom-deployment"}})
    subject.deploy(shell, service)
  end
end