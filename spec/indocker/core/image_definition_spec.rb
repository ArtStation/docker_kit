require 'spec_helper'

RSpec.describe Indocker::Core::ImageDefinition do
  subject{ Indocker::Core::ImageDefinition }
  
  context "image" do
    it "can build an image" do
      image = subject.new(:example_image).to_image
  
      expect(image.name).to eq(:example_image)
    end
  end

  context "dependencies" do
    it "sets image dependencies with symbol" do
      definition = subject
        .new(:example_image)
        .depends_on(:another_image)
  
      expect(definition.to_image.dependent_image_names).to eq([:another_image])
    end

    it "sets image dependencies with array" do
      definition = subject
        .new(:example_image)
        .depends_on([:first_image, :second_image])
  
      expect(definition.to_image.dependent_image_names).to eq([:first_image, :second_image])
    end

    it "sets image dependencies with proc" do
      definition = subject
        .new(:example_image)
        .depends_on{ [:first_image, :second_image] }
  
      expect(definition.to_image.dependent_image_names).to eq([:first_image, :second_image])
    end
  end

  context "registry" do
    it "sets image registry with symbol" do
      definition = subject
        .new(:example_image)
        .registry(:default)
  
      expect(definition.to_image.registry_name).to eq(:default)
    end

    it "sets image registry with proc" do
      definition = subject
        .new(:example_image)
        .registry{ :default }
  
      expect(definition.to_image.registry_name).to eq(:default)
    end
  end
end