RSpec.describe KuberKit::Actions::ConfigurationLoader do
  subject{ KuberKit::Actions::ConfigurationLoader.new }

  it "loads configuration definitions based on configuration_path" do
    expect(subject).to receive(:load_configurations).with("/opt/kuber_kit/configs", nil)
    subject.call(configurations_path: "/opt/kuber_kit/configs")
  end

  it "loads configuration definitions based on default path" do
    expect(subject).to receive(:load_configurations).with("/opt/kuber_kit/configurations", nil)
    subject.call(path: "/opt/kuber_kit")
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject).to receive(:load_configurations).and_raise(KuberKit::Error.new("Some error"))
    subject.call({})
  end

  it "prints error if minimal version is not met" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.configs).to receive(:kuber_kit_min_version).and_return("100.0.0")
    subject.call({})
  end

  context "when no configuration exists" do
    it "adds default configiration" do
      test_helper.configuration_store.reset!
      subject.call({})
      expect(test_helper.configuration_store.exists?(:_default_)).to eq(true)
    end
  end

  context "when one configuration exists" do
    it "doesn't add default configiration" do
      test_helper.configuration_store.define(:some_configuration)
      subject.call({configuration: "some_configuration"})
      expect(test_helper.configuration_store.exists?(:_default_)).to eq(false)
    end

    it "uses first found configuration" do
      test_helper.configuration_store.reset!
      test_helper.configuration_store.define(:some_configuration)

      subject.call({})

      expect(KuberKit.current_configuration.name).to eq(:some_configuration)
    end
  end

  context "when multiple configuration exists" do
    it "uses provided configuration" do
      test_helper.configuration_store.define(:some_configuration)
      test_helper.configuration_store.define(:another_configuration)

      expect(subject).to receive(:load_configurations).with(/configurations/, "some_configuration")
      subject.call({configuration: "some_configuration"})
    end

    it "print_error error if no configuration is selected" do
      test_helper.configuration_store.define(:some_configuration)
      test_helper.configuration_store.define(:another_configuration)

      expect(subject.ui).to receive(:prompt).with(/Please select configuration name/,  ["default", "some_configuration", "another_configuration"])

      allow(KuberKit).to receive(:set_configuration_name)

      subject.call({})
    end
  end
end