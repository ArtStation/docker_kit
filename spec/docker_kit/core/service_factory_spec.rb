require 'spec_helper'

RSpec.describe DockerKit::Core::ServiceFactory do
  subject{ DockerKit::Core::ServiceFactory.new() }
  let(:service_definition_factory) { test_helper.service_definition_factory }
  let(:test_definition) { service_definition_factory.create(:example).template(:service) }

  it "builds image based on image definition" do
    service = subject.create(test_definition)

    expect(service).to be_a(DockerKit::Core::Service)
    expect(service.name).to eq(:example)
  end

  it "raises error if template name wasn't set" do
    test_definition = service_definition_factory.create(:example)
    
    expect{subject.create(test_definition)}.to raise_error(DockerKit::Core::ServiceFactory::AttributeNotSetError)
  end
end