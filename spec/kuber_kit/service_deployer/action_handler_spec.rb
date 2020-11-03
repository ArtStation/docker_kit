RSpec.describe KuberKit::ServiceDeployer::ActionHandler do
  subject{ KuberKit::ServiceDeployer::ActionHandler.new }

  let(:service) { service_helper.service(:example) }
  let(:shell) { test_helper.shell }

  it "runs service deployer by service name" do
    expect(subject.service_store).to receive(:get_service).with(:example).and_return(service)
    expect(subject.deployer).to receive(:deploy).with(shell, service, :kubernetes)

    subject.call(shell, :example)
  end
end