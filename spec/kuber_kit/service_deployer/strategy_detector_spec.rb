RSpec.describe KuberKit::ServiceDeployer::StrategyDetector do
  subject{ KuberKit::ServiceDeployer::StrategyDetector.new }

  let(:service) { service_helper.register_service(:auth_app) }

  it "returns deployment strategy based on current configuration" do
    test_helper.configuration_store.get_definition(:default).deploy_strategy(:docker_compose)
    expect(subject.call(service)).to eq(:docker_compose)
  end
end