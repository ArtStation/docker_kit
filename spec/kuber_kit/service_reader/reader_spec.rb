RSpec.describe KuberKit::ServiceReader::Reader do
  subject{ KuberKit::ServiceReader::Reader.new }

  let(:service) { service_helper.service(:auth_app) }

  it "returns service config" do
    result = subject.read(test_helper.shell, service)
    expect(result).to eq("apiVersion: v1\nkind: Service\nmetadata:\n  name: \"auth_app\"\nspec:\n  selector:\n    app: test-app")
  end

  it "raises error if template name wasn't set" do
    service = service_helper.service(:auth_app, template: nil)
    
    expect{ subject.read(test_helper.shell, service) }.to raise_error(KuberKit::ServiceReader::Reader::AttributeNotSetError)
  end
end