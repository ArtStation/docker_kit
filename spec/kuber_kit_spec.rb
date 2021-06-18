RSpec.describe KuberKit do
  it "has a version number" do
    expect(KuberKit::VERSION).not_to be nil
  end

  it "allows setting configuration" do
    test_helper.configuration_store.define(:production)
    KuberKit.set_configuration_name(:production)
    expect(KuberKit.current_configuration.name).to eq(:production)
  end

  it "allows setting ui_mode" do
    default_ui_mode = KuberKit.ui_mode
    KuberKit.set_ui_mode(:debug)

    expect(KuberKit.ui_mode).to eq(:debug)

    KuberKit.set_ui_mode(default_ui_mode)
  end

  it "allows setting user" do
    default_user = KuberKit.user
    KuberKit.set_user(:bruce)

    expect(KuberKit.user).to eq(:bruce)

    KuberKit.set_user(default_user)
  end

  context "build_helper" do
    it "adds new methods to context helper" do
      KuberKit.build_helper do
        def test_url
          "test"
        end
      end

      helper = KuberKit::Core::ContextHelper::ContextHelperFactory.new.build_image_context(test_helper.shell, nil)
      expect(helper.test_url).to eq("test")
    end
  end
end
