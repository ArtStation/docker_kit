RSpec.describe KuberKit::Actions::ServiceDeployer do
  subject{ KuberKit::Actions::ServiceDeployer.new }

  let(:shell) { test_helper.shell }

  before do
    service_helper.register_service(:auth_app)
  end

  it "deploys services found by resolver" do
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :auth_app)
    subject.call(services: ["auth_app"], tags: [])
  end

  it "shows tags selection if no service found" do
    expect(subject.ui).to receive(:prompt).with("Please select which tag to deploy", any_args).and_return([["auth_app"], []])
    expect(subject.service_deployer).to receive(:call).with(subject.local_shell, :auth_app)
    subject.call(services: [], tags: [])
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.service_deployer).to receive(:call).and_raise(KuberKit::Error.new("Some error"))
    subject.call(services: ["auth_app"], tags: [])
  end
end