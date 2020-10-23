require 'spec_helper'

RSpec.describe Indocker::Core::ServiceDefinition do
  subject{ Indocker::Core::ServiceDefinition.new(:example_service) }

  context "initialize" do
    it "can initialize service with symbol name" do
      definition = Indocker::Core::ServiceDefinition.new(:example_service)
      expect(definition.service_name).to eq(:example_service)
    end

    it "can initialize service with string name" do
      definition = Indocker::Core::ServiceDefinition.new("example_service")
      expect(definition.service_name).to eq(:example_service)
    end
  end
end