RSpec.describe KuberKit::ServiceDeployer::ActionHandler do
  subject{ KuberKit::ServiceDeployer::ActionHandler.new }

  let(:service) { service_helper.service(:example) }
  let(:shell) { test_helper.shell }

  it "runs service deployer by service name and returns deployment result" do
    expect(subject.service_store).to receive(:get_service).with(:example).and_return(service)
    expect(subject.deployer).to receive(:deploy).with(shell, service, :kubernetes).and_return("deployment_result")

    result = subject.call(shell, :example)
    expect(result).to eq("deployment_result")
  end
end