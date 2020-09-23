require 'spec_helper'

RSpec.describe Indocker::Core::ImageFactory do
  subject{ Indocker::Core::ImageFactory.new }
  let(:image_definition_factory) { TestImageDefinitionFactory.new }
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
    expect(image.dependent_images.first).to be_a(Indocker::Core::Image)
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

  it "sets default dockerfile path" do
    image = subject.create(test_definition)

    expect(image.dockerfile_path).to eq("/images/example/Dockerfile")
  end
end