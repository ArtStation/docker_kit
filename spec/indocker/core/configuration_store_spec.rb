require 'spec_helper'

RSpec.describe Indocker::Core::ConfigurationStore do
  subject{ Indocker::Core::ConfigurationStore.new }
  let(:test_definition) { test_helper.configuration_definition(:production) }
   
  context "#define" do
    it "defines an configuration and returns ConfigurationDefinition" do
      definition = subject.define(:production)
      expect(definition).to be_a(Indocker::Core::ConfigurationDefinition)
    end
  end

  context "#get_definition" do
    it "returns already created definition" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:production)
      expect(definition).to be_a(Indocker::Core::ConfigurationDefinition)
    end

    it "returns the same object each time" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:production)
      expect(definition).to eq(test_definition)
    end

    it "raises NotFound error if image is not found" do
      expect{ subject.get_definition(:production) }.to raise_error(Indocker::Core::ConfigurationStore::NotFoundError)
    end
  end

  context "#add_definition" do
    it "adds ConfigurationDefinition object to the store" do
      subject.add_definition(test_definition)
      expect(subject.get_definition(:production)).to be_a(Indocker::Core::ConfigurationDefinition)
    end

    it "doesn't allow adding a definition twice" do
      subject.add_definition(test_definition)
      expect{ subject.add_definition(test_definition) }.to raise_error(Indocker::Core::ConfigurationStore::AlreadyAddedError)
    end
  end

  context "#get_configuration" do
    it "returns a configuration based on definition" do
      subject.add_definition(test_definition)

      configuration = subject.get_configuration(:production)

      expect(configuration).to be_a(Indocker::Core::Configuration)
      expect(configuration.name).to eq(:production)
    end
  end

  context "#load_definitions" do
    it "loads definitions by file name pattern" do
      expect(subject.local_shell).to receive(:recursive_list_files).and_return(["/configurations/production.rb"])
      expect(subject).to receive(:load_definition).with("/configurations/production.rb")

      subject.load_definitions("/configurations/")
    end
  end
end