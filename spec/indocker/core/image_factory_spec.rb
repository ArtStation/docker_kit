require 'spec_helper'

RSpec.describe Indocker::Core::ImageFactory do
  subject{ Indocker::Core::ImageFactory.new() }
  let(:image_definition_factory) { test_helper.image_definition_factory }
  let(:test_definition) { image_definition_factory.create(:example) }

  it "builds image based on image definition" do
    image = subject.create(test_definition)

    expect(image).to be_a(Indocker::Core::Image)
    expect(image.name).to eq(:example)
  end

  it "builds image for dependent image definitions" do
    example_definition = image_definition_factory
      .create(:example_image)
      .depends_on(:another_image)

    another_definition = image_definition_factory
      .create(:another_image)
    
    image = subject.create(example_definition, all_definitions: {
      example_image: example_definition,
      another_image: another_definition,
    })
    expect(image.dependencies.first).to be_a(Indocker::Core::Image)
  end

  it "raises error on circular dependency" do
    example_definition = image_definition_factory
      .create(:example_image)
      .depends_on(:another_image)

    another_definition = image_definition_factory
      .create(:another_image)
      .depends_on(:example_image)
    
    expect{ subject.create(example_definition, all_definitions: {
      example_image: example_definition,
      another_image: another_definition,
    }) }.to raise_error(Indocker::Core::ImageFactory::CircularDependencyError)
  end

  it "raises error if dependent image is not found" do
    example_definition = image_definition_factory
      .create(:example_image)
      .depends_on(:not_found_image)
    
    expect{ subject.create(example_definition) }.to raise_error(Indocker::Core::ImageFactory::DependencyNotFoundError)
  end

  it "sets default dockerfile path" do
    image = subject.create(test_definition)

    expect(image.dockerfile_path).to eq("/images/example/Dockerfile")
  end

  it "sets default build context if it exists" do
    image = subject.create(test_definition)

    expect(image.build_context_dir).to eq("/images/example/build_context")
  end

  it "doesn't set default build context if it's absent" do
    subject.file_presence_checker.lost_path!("/images/example/build_context")

    image = subject.create(test_definition)

    expect(image.build_context_dir).to eq(nil)
  end

  it "validates dockerfile presence" do
    definition = image_definition_factory.create(:example).dockerfile("/path/to/Dockerfile")

    image = subject.create(definition)

    expect(subject.file_presence_checker.file_checked?("/path/to/Dockerfile")).to be(true)
  end

  it "validates build context dir presence" do
    definition = image_definition_factory.create(:example).build_context("/path/to/build_context/")

    image = subject.create(definition)

    expect(subject.file_presence_checker.dir_checked?("/path/to/build_context/")).to be(true)
  end
end