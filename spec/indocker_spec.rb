RSpec.describe Indocker do
  it "has a version number" do
    expect(Indocker::VERSION).not_to be nil
  end

  it "allows setting configuration" do
    test_helper.configuration_store.define(:production)
    Indocker.set_configuration_name(:production)
    expect(Indocker.current_configuration.name).to eq(:production)
  end

  context "build_helper" do
    it "adds new methods to context helper" do
      Indocker.build_helper do
        def test_url
          "test"
        end
      end

      helper = Indocker::Compiler::ContextHelperFactory.new.create(test_helper.shell)
      expect(helper.test_url).to eq("test")
    end
  end
end
