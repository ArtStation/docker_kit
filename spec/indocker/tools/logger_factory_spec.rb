RSpec.describe Indocker::Tools::LoggerFactory do
  subject{ Indocker::Tools::LoggerFactory.new }

  it do
    expect(subject.create(STDOUT)).to be_a(Logger)
  end
end