RSpec.describe KuberKit::ServiceDeployer::Strategies::Abstract do
  subject{ KuberKit::ServiceDeployer::Strategies::Abstract.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.register_service(:auth_app) }

  it do
    expect{ subject.deploy(test_helper.shell, service) }.to raise_error(KuberKit::NotImplementedError)
  end
end