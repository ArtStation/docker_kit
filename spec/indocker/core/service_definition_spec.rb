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

  context "template" do
    it "sets service template name with symbol" do
      definition = subject.template(:service_template)
  
      expect(definition.to_service_attrs.template_name).to eq(:service_template)
    end

    it "sets service template with proc" do
      definition = subject.template{ :service_template }
  
      expect(definition.to_service_attrs.template_name).to eq(:service_template)
    end
  end
end