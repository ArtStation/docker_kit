RSpec.describe KuberKit::Actions::ServiceGenerator do
  subject{ KuberKit::Actions::ServiceGenerator.new(local_shell: shell) }

  let(:shell) { test_helper.shell }
  let(:configs) { KuberKit::Configs.new }

  before do
    service_helper.register_service(:identity_app, images: [:identity_image], tags: ["identity"])
  end

  it "generates a template for a given service" do
    expect(shell).to receive(:exec!).with("mkdir -p \"/tmp/identity_app_chart\"", merge_stderr: true)
    expect(shell).to receive(:exec!).with("mkdir -p \"/tmp/identity_app_chart/templates\"", merge_stderr: true)
    
    subject.call(:identity_app, "/tmp")
  end
end