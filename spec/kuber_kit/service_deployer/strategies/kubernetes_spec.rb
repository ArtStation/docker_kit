RSpec.describe KuberKit::ServiceDeployer::Strategies::Kubernetes do
  subject{ KuberKit::ServiceDeployer::Strategies::Kubernetes.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.service(:auth_app) }
  let(:service_config_path) { File.join("~", ".kuber_kit/services/auth_app.yml") }

  it "applies kubernetes config" do
    expect(shell).to receive(:write).with(service_config_path, /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:apply_file).with(
      shell, service_config_path, kubeconfig_path: nil, namespace: nil
    )
    subject.deploy(shell, service)
  end

  it "restarts service if it exists" do
    expect(shell).to receive(:write).with(service_config_path, /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:resource_exists?).and_return(true)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to receive(:rolling_restart).with(
      shell, "deployment", "auth-app", kubeconfig_path: nil, namespace: nil
    )
    expect(subject.kubectl_commands).to receive(:rollout_status).with(
      shell, "deployment", "auth-app", wait: true, kubeconfig_path: nil, namespace: nil
    )

    subject.deploy(shell, service)
  end

  it "doesn't restart deployment if it's disabled for service" do
    expect(shell).to receive(:write).with(service_config_path, /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:resource_exists?).and_return(true)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to_not receive(:rolling_restart)

    service = service_helper.service(:auth_app, attributes: {deployer: {restart_if_exists: false}})
    subject.deploy(shell, service)
  end

  it "doesn't wait for rollout status deployment if it's disabled for service" do
    expect(shell).to receive(:write).with(service_config_path, /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:resource_exists?).and_return(true)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to receive(:rolling_restart)
    expect(subject.kubectl_commands).to_not receive(:rollout_status)

    service = service_helper.service(:auth_app, attributes: {deployer: {restart_if_exists: true, wait_for_rollout: false}})
    subject.deploy(shell, service)
  end

  it "deletes previous deployment if it's enabled for service" do
    expect(shell).to receive(:write).with(/auth_job/, /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:resource_exists?).and_return(true)
    expect(subject.kubectl_commands).to receive(:delete_resource).with(shell, "job", "auth-job", kubeconfig_path: nil, namespace: nil)
    expect(subject.kubectl_commands).to receive(:apply_file).with(
      shell, /auth_job/, kubeconfig_path: nil, namespace: nil
    )

    service = service_helper.service(:auth_job, attributes: {deployer: {resource_type: "job", delete_if_exists: true}})
    subject.deploy(shell, service)
  end

  it "uses custom deployment name if provided" do
    expect(shell).to receive(:write).with(service_config_path, /apiVersion: v1/)
    expect(subject.kubectl_commands).to receive(:resource_exists?).and_return(true)
    expect(subject.kubectl_commands).to receive(:apply_file)
    expect(subject.kubectl_commands).to receive(:rolling_restart).with(
      shell, "deployment", "custom-deployment", kubeconfig_path: nil, namespace: nil
    )

    service = service_helper.service(:auth_app, attributes: {deployer: {resource_name: "custom-deployment"}})
    subject.deploy(shell, service)
  end
end