RSpec.describe KuberKit::ServiceDeployer::StrategyDetector do
  subject{ KuberKit::ServiceDeployer::StrategyDetector.new }

  it "returns deployment strategy based on service attrs" do
    service = service_helper.service(:auth_app, deployer_strategy: :kubernetes_runner)
    expect(subject.call(service)).to eq(:kubernetes_runner)
  end

  it "returns deployment strategy based on current configuration" do
    test_helper.configuration_store.get_definition(:default).deployer_strategy(:docker_compose)
    service = service_helper.service(:auth_app)
    expect(subject.call(service)).to eq(:docker_compose)
  end
end