RSpec.describe Indocker::ServiceDeployer::ServiceListResolver do
  subject{ Indocker::ServiceDeployer::ServiceListResolver.new }

  before do
    test_helper.service_store.define(:auth_app)
    test_helper.service_store.define(:marketplace_app)
  end

  it "finds service with services option" do
    result = subject.resolve(services: [:auth_app])
    expect(result).to eq([:auth_app])
  end
end