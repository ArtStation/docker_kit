RSpec.describe KuberKit::ServiceGenerator::StrategyDetector do
  subject{ KuberKit::ServiceGenerator::StrategyDetector.new }

  it "returns deployment strategy based on service attrs" do
    service = service_helper.service(:auth_app, generator_strategy: :kubernetes)
    expect(subject.call(service)).to eq(:kubernetes)
  end

  it "returns deployment strategy based on current configuration" do
    test_helper.configuration_store.get_definition(:default).generator_strategy(:docker_compose)
    service = service_helper.service(:auth_app)
    expect(subject.call(service)).to eq(:docker_compose)
  end
end