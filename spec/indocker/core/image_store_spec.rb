require 'spec_helper'

RSpec.describe Indocker::Core::ImageStore do
  subject{ Indocker::Core::ImageStore.new(image_factory: get_test_image_factory) }
  let(:test_definition) { get_test_image_definition(:example) }
   
  context "#define" do
    it "defines an image and returns ImageDefinition" do
      definition = subject.define(:example, "/images/example")
      expect(definition).to be_a(Indocker::Core::ImageDefinition)
    end
  end

  context "#get_definition" do
    it "returns already created definition" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:example)
      expect(definition).to be_a(Indocker::Core::ImageDefinition)
    end

    it "returns the same object each time" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:example)
      expect(definition).to eq(test_definition)
    end

    it "raises NotFound error if image is not found" do
      expect{ subject.get_definition(:example) }.to raise_error(Indocker::Core::ImageStore::NotFoundError)
    end
  end

  context "#add_definition" do
    it "adds ImageDefinition object to the store" do
      subject.add_definition(test_definition)
      expect(subject.get_definition(:example)).to be_a(Indocker::Core::ImageDefinition)
    end

    it "doesn't allow adding a definition twice" do
      subject.add_definition(test_definition)
      expect{ subject.add_definition(test_definition) }.to raise_error(Indocker::Core::ImageStore::AlreadyAddedError)
    end
  end

  context "#get_image" do
    it "returns an image based on definition" do
      subject.add_definition(test_definition)

      image = subject.get_image(:example)

      expect(image).to be_a(Indocker::Core::Image)
      expect(image.name).to eq(:example)
    end
  end
end