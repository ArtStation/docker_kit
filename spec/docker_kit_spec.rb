RSpec.describe DockerKit do
  it "has a version number" do
    expect(DockerKit::VERSION).not_to be nil
  end

  it "allows setting configuration" do
    test_helper.configuration_store.define(:production)
    DockerKit.set_configuration_name(:production)
    expect(DockerKit.current_configuration.name).to eq(:production)
  end

  context "build_helper" do
    it "adds new methods to context helper" do
      DockerKit.build_helper do
        def test_url
          "test"
        end
      end

      helper = DockerKit::Core::ContextHelper::ContextHelperFactory.new.build_image_context(test_helper.shell)
      expect(helper.test_url).to eq("test")
    end
  end
end
