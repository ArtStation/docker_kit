RSpec.describe KuberKit::ServiceGenerator::Strategies::Abstract do
  subject{ KuberKit::ServiceGenerator::Strategies::Abstract.new }

  let(:shell) { test_helper.shell }
  let(:service) { service_helper.register_service(:auth_app) }

  it do
    expect{ subject.generate(test_helper.shell, service, "/tmp") }.to raise_error(KuberKit::NotImplementedError)
  end
end