RSpec.describe KuberKit::ServiceGenerator::Generator do
  subject{ KuberKit::ServiceGenerator::Generator.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.register_service(:auth_app) }

  class ExampleGeneratorStrategy < KuberKit::ServiceGenerator::Strategies::Abstract
    def initialize(name:)
      @name = name
    end

    def generate(shell, service)
      return {name: @name}
    end
  end

  let(:strategy2) { ExampleGeneratorStrategy.new(name: :strategy2) }
  let(:strategy1) { ExampleGeneratorStrategy.new(name: :strategy1) }

  it "calls the strategy with given name" do
    subject.register_strategy(:strategy1, strategy1)
    subject.register_strategy(:strategy2, strategy2)

    result1 = subject.generate(test_helper.shell, service, :strategy1)
    result2 = subject.generate(test_helper.shell, service, :strategy2)

    expect(result1[:name]).to eq(:strategy1)
    expect(result2[:name]).to eq(:strategy2)
  end

  it "raises error if strategy not found" do
    expect {
      subject.generate(test_helper.shell, service, :strategy3)
    }.to raise_error(KuberKit::ServiceGenerator::Generator::StrategyNotFoundError)
  end

  it "raises an error if strategy is not an instance of abstract generator" do
    expect {
      subject.register_strategy(:strategy4, KuberKit)
    }.to raise_error(ArgumentError)
  end
end