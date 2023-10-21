RSpec.describe KuberKit::ServiceGenerator::Strategies::Helm do
  subject{ KuberKit::ServiceGenerator::Strategies::Helm.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.service(:auth_app, generator_strategy: :helm) }
  let(:export_path)       { File.expand_path(File.join("~", ".kuber_kit", "services")) }
  let(:chart_root_path)   { File.join(export_path, "auth_app_chart") }
  let(:release_path)      { File.join(chart_root_path, "templates/release.yaml") }
  let(:chart_config_path) { File.join(chart_root_path, "Chart.yaml") }

  it "generates the templates" do
    expect(shell).to receive(:write).with(release_path, /apiVersion: v1/)
    expect(shell).to receive(:write).with(chart_config_path, /name: auth-app/)
    subject.generate(shell, service, export_path)
  end
end