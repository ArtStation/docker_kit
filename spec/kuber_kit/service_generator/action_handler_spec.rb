RSpec.describe KuberKit::ServiceGenerator::ActionHandler do
  subject{ KuberKit::ServiceGenerator::ActionHandler.new }

  let(:service) { service_helper.service(:example) }
  let(:shell) { test_helper.shell }

  it "runs service generator by service name" do
    expect(subject.service_store).to receive(:get_service).with(:example).and_return(service)
    expect(subject.generator).to receive(:generate).with(shell, service, :helm).and_return("deployment_result")

    result = subject.call(shell, :example)
  end
end