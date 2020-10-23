require 'spec_helper'

RSpec.describe Indocker::Core::ServiceFactory do
  subject{ Indocker::Core::ServiceFactory.new() }
  let(:service_definition_factory) { test_helper.service_definition_factory }
  let(:test_definition) { service_definition_factory.create(:example) }

  it "builds image based on image definition" do
    service = subject.create(test_definition)

    expect(service).to be_a(Indocker::Core::Service)
    expect(service.name).to eq(:example)
  end
end