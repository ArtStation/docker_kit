RSpec.describe DockerKit::Tools::LoggerFactory do
  subject{ DockerKit::Tools::LoggerFactory.new }

  it do
    expect(subject.create(STDOUT)).to be_a(Logger)
  end
end