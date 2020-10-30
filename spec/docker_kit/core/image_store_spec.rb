require 'spec_helper'

RSpec.describe DockerKit::Core::ImageStore do
  subject{ DockerKit::Core::ImageStore.new }
  let(:test_definition) { test_helper.image_definition(:example) }
   
  context "#define" do
    it "defines an image and returns ImageDefinition" do
      definition = subject.define(:example, "/images/example")
      expect(definition).to be_a(DockerKit::Core::ImageDefinition)
    end

    it "can define image name as string" do
      definition = subject.define("example", "/images/example")
      expect(definition.image_name).to eq(:example)
    end
  end

  context "#get_definition" do
    it "returns already created definition" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:example)
      expect(definition).to be_a(DockerKit::Core::ImageDefinition)
    end

    it "returns the same object each time" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:example)
      expect(definition).to eq(test_definition)
    end

    it "raises NotFound error if image is not found" do
      expect{ subject.get_definition(:example) }.to raise_error(DockerKit::Core::ImageStore::NotFoundError)
    end
  end

  context "#add_definition" do
    it "adds ImageDefinition object to the store" do
      subject.add_definition(test_definition)
      expect(subject.get_definition(:example)).to be_a(DockerKit::Core::ImageDefinition)
    end

    it "doesn't allow adding a definition twice" do
      subject.add_definition(test_definition)
      expect{ subject.add_definition(test_definition) }.to raise_error(DockerKit::Core::ImageStore::AlreadyAddedError)
    end
  end

  context "#get_image" do
    it "returns an image based on definition" do
      subject.add_definition(test_definition)

      image = subject.get_image(:example)

      expect(image).to be_a(DockerKit::Core::Image)
      expect(image.name).to eq(:example)
    end
  end

  context "#load_definitions" do
    it "loads definitions by file name pattern" do
      expect(subject.local_shell).to receive(:recursive_list_files).and_return(["/images/example/image.rb"])
      expect(subject).to receive(:load_definition).with("/images/example/image.rb")

      subject.load_definitions("/images/")
    end
  end
end