RSpec.describe KuberKit do
  it "has a version number" do
    expect(KuberKit::VERSION).not_to be nil
  end

  it "allows setting configuration" do
    test_helper.configuration_store.define(:production)
    KuberKit.set_configuration_name(:production)
    expect(KuberKit.current_configuration.name).to eq(:production)
  end

  context "build_helper" do
    it "adds new methods to context helper" do
      KuberKit.build_helper do
        def test_url
          "test"
        end
      end

      helper = KuberKit::Core::ContextHelper::ContextHelperFactory.new.build_image_context(test_helper.shell)
      expect(helper.test_url).to eq("test")
    end
  end
end
