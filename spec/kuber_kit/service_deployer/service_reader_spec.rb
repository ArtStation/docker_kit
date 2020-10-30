RSpec.describe KuberKit::ServiceDeployer::ServiceReader do
  subject{ KuberKit::ServiceDeployer::ServiceReader.new }

  let(:service) { service_helper.register_service(:auth_app) }

  it "returns service config" do
    result = subject.read(test_helper.shell, service)
    expect(result).to eq("apiVersion: v1\nkind: Service\nmetadata:\n  name: \"auth_app\"\nspec:\n  selector:\n    app: test-app")
  end
end