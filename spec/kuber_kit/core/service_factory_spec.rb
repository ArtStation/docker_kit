require 'spec_helper'

RSpec.describe KuberKit::Core::ServiceFactory do
  subject{ KuberKit::Core::ServiceFactory.new() }
  let(:test_definition) { service_helper.definition(:example).template(:service) }

  it "builds image based on image definition" do
    service = subject.create(test_definition)

    expect(service).to be_a(KuberKit::Core::Service)
    expect(service.name).to eq(:example)
  end

  it "raises error if template name wasn't set" do
    test_definition = service_helper.definition_factory.create(:example)
    
    expect{subject.create(test_definition)}.to raise_error(KuberKit::Core::ServiceFactory::AttributeNotSetError)
  end
end