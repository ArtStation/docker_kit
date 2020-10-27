require 'spec_helper'

RSpec.describe Indocker::Core::ServiceFactory do
  subject{ Indocker::Core::ServiceFactory.new() }
  let(:service_definition_factory) { test_helper.service_definition_factory }
  let(:test_definition) { service_definition_factory.create(:example).template(:service) }

  it "builds image based on image definition" do
    service = subject.create(test_definition)

    expect(service).to be_a(Indocker::Core::Service)
    expect(service.name).to eq(:example)
  end

  it "raises error if template name wasn't set" do
    test_definition = service_definition_factory.create(:example)
    
    expect{subject.create(test_definition)}.to raise_error(Indocker::Core::ServiceFactory::AttributeNotSetError)
  end
end