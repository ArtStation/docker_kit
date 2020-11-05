require 'spec_helper'

RSpec.describe KuberKit::Core::ServiceStore do
  subject{ KuberKit::Core::ServiceStore.new }
  let(:test_definition) { service_helper.definition(:example).template(:service) }
   
  context "#define" do
    it "defines an service and returns ServiceDefinition" do
      definition = subject.define(:example)
      expect(definition).to be_a(KuberKit::Core::ServiceDefinition)
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
      expect(definition).to be_a(KuberKit::Core::ServiceDefinition)
    end

    it "returns the same object each time" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:example)
      expect(definition).to eq(test_definition)
    end

    it "raises NotFound error if service is not found" do
      expect{ subject.get_definition(:example) }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end

  context "#get_service" do
    it "returns an service based on definition" do
      subject.add_definition(test_definition)

      service = subject.get_service(:example)

      expect(service).to be_a(KuberKit::Core::Service)
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