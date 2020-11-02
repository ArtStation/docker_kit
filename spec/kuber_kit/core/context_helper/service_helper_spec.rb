RSpec.describe KuberKit::Core::ContextHelper::ServiceHelper do
  let(:service) { service_helper.service(:auth_app) }

  subject{ KuberKit::Core::ContextHelper::ServiceHelper.new(
    image_store:    test_helper.image_store,
    artifact_store: KuberKit::Container['core.artifact_store'],
    shell:          test_helper.shell,
    service:        service
  ) }

  context "service_name" do
    it "returns service name of current service" do
      expect(subject.service_name).to eq("auth_app")
    end
  end

  context "service_uri" do
    it "returns parametrized service name of current service" do
      expect(subject.service_uri).to eq("auth-app")
    end
  end

  context "attribute" do
    let(:service) { service_helper.service(:auth_app, attributes: {scale: 2, nil_attr: nil}) }
    
    it "returns attribute assigned to the service" do
      expect(subject.attribute(:scale)).to eq(2)
    end

    it "returns attribute rewritten in configuration" do
      test_helper.configuration_store.get_definition(:default).enabled_services(auth_app: {scale: 3})

      expect(subject.attribute(:scale)).to eq(3)
    end

    it "returns nil if attribute is nil" do
      expect(subject.attribute(:nil_attr)).to eq(nil)
    end

    it "raises an error if attribute wasn't set" do
      expect{ subject.attribute(:unset_attr) }.to raise_error(KuberKit::Core::Service::AttributeNotSet)
    end
  end
end