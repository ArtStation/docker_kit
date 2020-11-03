RSpec.describe KuberKit::Actions::ServiceDeployer do
  subject{ KuberKit::Actions::ServiceDeployer.new }

  let(:shell) { test_helper.shell }

  before do
    service_helper.register_service(:auth_app)
  end

  it "deploys services found by resolver" do
    expect(subject.action_handler).to receive(:call).with(subject.local_shell, :auth_app)
    subject.call(services: ["auth_app"], tags: [])
  end
end