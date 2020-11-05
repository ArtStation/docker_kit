require 'spec_helper'

RSpec.describe KuberKit::Core::ImageStore do
  subject{ KuberKit::Core::ImageStore.new }
  let(:test_definition) { test_helper.image_definition(:example) }
   
  context "#define" do
    it "defines an image and returns ImageDefinition" do
      definition = subject.define(:example, "/images/example")
      expect(definition).to be_a(KuberKit::Core::ImageDefinition)
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
      expect(definition).to be_a(KuberKit::Core::ImageDefinition)
    end

    it "returns the same object each time" do
      subject.add_definition(test_definition)
      definition = subject.get_definition(:example)
      expect(definition).to eq(test_definition)
    end

    it "raises NotFound error if image is not found" do
      expect{ subject.get_definition(:example) }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end

  context "#get_image" do
    it "returns an image based on definition" do
      subject.add_definition(test_definition)

      image = subject.get_image(:example)

      expect(image).to be_a(KuberKit::Core::Image)
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