require 'spec_helper'

RSpec.describe Indocker::Core::ImageDefinition do
  subject{ Indocker::Core::ImageDefinition.new(:example_image) }
  
  context "image" do
    it "can build an image" do
      image = subject.to_image
  
      expect(image.name).to eq(:example_image)
    end
  end

  context "dependencies" do
    it "sets image dependencies with symbol" do
      definition = subject.depends_on(:another_image)
  
      expect(definition.to_image.dependent_image_names).to eq([:another_image])
    end

    it "sets image dependencies with array" do
      definition = subject.depends_on([:first_image, :second_image])
  
      expect(definition.to_image.dependent_image_names).to eq([:first_image, :second_image])
    end

    it "sets image dependencies with proc" do
      definition = subject.depends_on{ [:first_image, :second_image] }
  
      expect(definition.to_image.dependent_image_names).to eq([:first_image, :second_image])
    end
  end

  context "registry" do
    it "sets image registry with symbol" do
      definition = subject.registry(:default)
  
      expect(definition.to_image.registry_name).to eq(:default)
    end

    it "sets image registry with proc" do
      definition = subject.registry{ :default }
  
      expect(definition.to_image.registry_name).to eq(:default)
    end
  end

  context "dockerfile" do
    it "sets dockerfile path with symbol" do
      definition = subject.dockerfile("/path/to/dockerfile")
  
      expect(definition.to_image.dockerfile_path).to eq("/path/to/dockerfile")
    end

    it "sets dockerfile path with proc" do
      definition = subject.dockerfile{ "/path/to/dockerfile" }
  
      expect(definition.to_image.dockerfile_path).to eq("/path/to/dockerfile")
    end
  end

  context "build_args" do
    it "sets build_args with symbol" do
      definition = subject.build_args({health_check_url: "/test"})
  
      expect(definition.to_image.build_args).to eq({health_check_url: "/test"})
    end

    it "sets build_args with proc" do
      definition = subject.build_args{ {health_check_url: "/test"} }
  
      expect(definition.to_image.build_args).to eq({health_check_url: "/test"})
    end
  end
end