RSpec.describe KuberKit::Tools::LoggerFactory do
  subject{ KuberKit::Tools::LoggerFactory.new }

  it do
    expect(subject.create(STDOUT)).to be_a(Logger)
  end
end