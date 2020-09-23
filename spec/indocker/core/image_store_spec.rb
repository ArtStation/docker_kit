require 'spec_helper'

RSpec.describe Indocker::Core::ImageStore do
  subject{ Indocker::Core::ImageStore.new }

  context "#define" do
    it "defines an image and returns ImageDefinition" do
      definition = subject.define(:example)
      expect(definition).to be_a(Indocker::Core::ImageDefinition)
    end
  end

  context "#get_definition" do
    it "returns already created definition" do
      subject.define(:example)
      definition = subject.get_definition(:example)
      expect(definition).to be_a(Indocker::Core::ImageDefinition)
    end

    it "returns the same object each time" do
      definition1 = subject.define(:example)
      definition2 = subject.get_definition(:example)
      expect(definition1).to eq(definition2)
    end

    it "raises NotFound error if image is not found" do
      expect{ subject.get_definition(:example) }.to raise_error(Indocker::Core::ImageStore::NotFoundError)
    end
  end

  context "#add_definition" do
    it "adds ImageDefinition object to the store" do
      definition = Indocker::Core::ImageDefinition.new(:example)
      subject.add_definition(definition)
      expect(subject.get_definition(:example)).to be_a(Indocker::Core::ImageDefinition)
    end

    it "doesn't allow adding a definition twice" do
      definition = Indocker::Core::ImageDefinition.new(:example)
      subject.add_definition(definition)
      expect{ subject.add_definition(definition) }.to raise_error(Indocker::Core::ImageStore::AlreadyAddedError)
    end
  end

  context "#get_image" do
    it "returns an image based on definition" do
      subject.define(:example_image)

      image = subject.get_image(:example_image)

      expect(image).to be_a(Indocker::Core::Image)
      expect(image.name).to eq(:example_image)
    end
  end
end