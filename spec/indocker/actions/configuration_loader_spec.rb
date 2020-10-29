RSpec.describe Indocker::Actions::ConfigurationLoader do
  subject{ Indocker::Actions::ConfigurationLoader.new }

  it "loads configuration definitions based on configuration_path" do
    expect(subject).to receive(:load_configurations).with("/opt/indocker/configs", :_default_)
    subject.call(configurations_path: "/opt/indocker/configs")
  end

  it "loads configuration definitions based on default path" do
    expect(subject).to receive(:load_configurations).with("/opt/indocker/configurations", :_default_)
    subject.call(path: "/opt/indocker")
  end

  context "when no configuration exists" do
    it "adds default configiration" do
      test_helper.configuration_store.reset!
      subject.call({path: "/tmp/not_existing_dir"})
      expect(test_helper.configuration_store.exists?(:_default_)).to eq(true)
    end
  end

  context "when some configuration exists" do
    it "doesn't add default configiration" do
      test_helper.configuration_store.define(:some_configuration)
      subject.call({path: "/tmp/not_existing_dir", configuration: "some_configuration"})
      expect(test_helper.configuration_store.exists?(:_default_)).to eq(false)
    end
  end
end