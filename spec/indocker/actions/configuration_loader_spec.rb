RSpec.describe Indocker::Actions::ConfigurationLoader do
  subject{ Indocker::Actions::ConfigurationLoader.new }

  it "loads configuration definitions based on configuration_path" do
    expect(subject).to receive(:load_configurations).with("/opt/indocker/configs", nil)
    subject.call(configurations_path: "/opt/indocker/configs")
  end

  it "loads configuration definitions based on default path" do
    expect(subject).to receive(:load_configurations).with("/opt/indocker/configurations", nil)
    subject.call(path: "/opt/indocker")
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

      expect(Indocker.current_configuration.name).to eq(:some_configuration)
    end
  end

  context "when multiple configuration exists" do
    it "uses provided configuration" do
      test_helper.configuration_store.define(:some_configuration)
      test_helper.configuration_store.define(:another_configuration)

      expect(subject).to receive(:load_configurations).with(/configurations/, "some_configuration")
      subject.call({configuration: "some_configuration"})
    end

    it "raises error if no configuration is selected" do
      test_helper.configuration_store.define(:some_configuration)
      test_helper.configuration_store.define(:another_configuration)

      expect{ subject.call({}) }.to raise_error(Indocker::Error)
    end
  end
end