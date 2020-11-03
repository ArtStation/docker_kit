RSpec.describe KuberKit::ServiceDeployer::Deployer do
  subject{ KuberKit::ServiceDeployer::Deployer.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.register_service(:auth_app) }

  class ExampleStrategy < KuberKit::ServiceDeployer::Strategies::Abstract
    def initialize(name:)
      @name = name
    end

    def deploy(shell, service)
      return {name: @name}
    end
  end

  let(:strategy2) { ExampleStrategy.new(name: :strategy2) }
  let(:strategy1) { ExampleStrategy.new(name: :strategy1) }

  it "calls the strategy with given name" do
    subject.register_strategy(:strategy1, strategy1)
    subject.register_strategy(:strategy2, strategy2)

    result1 = subject.deploy(test_helper.shell, service, :strategy1)
    result2 = subject.deploy(test_helper.shell, service, :strategy2)

    expect(result1[:name]).to eq(:strategy1)
    expect(result2[:name]).to eq(:strategy2)
  end

  it "raises error if strategy not found" do
    expect {
      subject.deploy(test_helper.shell, service, :strategy3)
    }.to raise_error(KuberKit::ServiceDeployer::Deployer::StrategyNotFoundError)
  end

  it "raises an error if strategy is not an instance of abstract reader" do
    expect {
      subject.register_strategy(:strategy4, KuberKit)
    }.to raise_error(ArgumentError)
  end
end