RSpec.describe Indocker do
  it "has a version number" do
    expect(Indocker::VERSION).not_to be nil
  end

  xit "allows setting configuration" do
    Indocker.set_configuration_name(:production)
    expect(Indocker.current_configuration.name).to eq(:production)
  end
end
