RSpec.describe KuberKit::ServiceDeployer::Strategies::Helm do
  subject{ KuberKit::ServiceDeployer::Strategies::Helm.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.service(:auth_app, deployer_strategy: :helm) }
  let(:chart_root_path)   { File.expand_path(File.join("~", ".kuber_kit", "services", "auth_app_chart")) }
  let(:release_path)      { File.join(chart_root_path, "templates/release.yaml") }
  let(:chart_config_path) { File.join(chart_root_path, "Chart.yaml") }

  it "launches helm upgrade" do
    expect(shell).to receive(:write).with(release_path, /apiVersion: v1/)
    expect(shell).to receive(:write).with(chart_config_path, /name: auth-app/)
    expect(subject.helm_commands).to receive(:upgrade).with(
      shell, chart_root_path, kubeconfig_path: nil, namespace: nil
    )
    subject.deploy(shell, service)
  end
end