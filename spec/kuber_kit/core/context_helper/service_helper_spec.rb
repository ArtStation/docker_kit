RSpec.describe KuberKit::Core::ContextHelper::BaseHelper do
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
end