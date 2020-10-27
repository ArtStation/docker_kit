require 'spec_helper'

RSpec.describe Indocker::Core::ServiceStore do
  subject{ Indocker::Core::ServiceStore.new }
  let(:test_definition) { test_helper.service_definition(:example).template(:service) }
   
  context "#define" do
    it "defines an service and returns ServiceDefinition" do
      definition = subject.define(:example)
      expect(definition).to be_a(Indocker::Core::ServiceDefinition)
    end

    it "can define service name as string" do
      definition = subject.define("example")
      expect(definition.service_name).to eq(:example)
    end
  end

  context "#get_definition" do
    it "returns already created definition" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:example)
      expect(definition).to be_a(Indocker::Core::ServiceDefinition)
    end

    it "returns the same object each time" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:example)
      expect(definition).to eq(test_definition)
    end

    it "raises NotFound error if service is not found" do
      expect{ subject.get_definition(:example) }.to raise_error(Indocker::Core::ServiceStore::NotFoundError)
    end
  end

  context "#add_definition" do
    it "adds ServiceDefinition object to the store" do
      subject.add_definition(test_definition)
      expect(subject.get_definition(:example)).to be_a(Indocker::Core::ServiceDefinition)
    end

    it "doesn't allow adding a definition twice" do
      subject.add_definition(test_definition)
      expect{ subject.add_definition(test_definition) }.to raise_error(Indocker::Core::ServiceStore::AlreadyAddedError)
    end
  end

  context "#get_service" do
    it "returns an service based on definition" do
      subject.add_definition(test_definition)

      service = subject.get_service(:example)

      expect(service).to be_a(Indocker::Core::Service)
      expect(service.name).to eq(:example)
    end
  end

  context "#load_definitions" do
    it "loads definitions by file name pattern" do
      expect(subject.local_shell).to receive(:recursive_list_files).and_return(["/services/myapp.rb"])
      expect(subject).to receive(:load_definition).with("/services/myapp.rb")

      subject.load_definitions("/services/")
    end
  end
end