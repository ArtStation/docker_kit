RSpec.describe Indocker::Actions::ImageCompiler do
  subject{ Indocker::Actions::ImageCompiler.new }

  xit "compiles image with dependencies" do
    image1_def = test_helper.image_definition_factory.create(:image1)
    image2_def = test_helper.image_definition_factory.create(:image2).depends_on(:image1)

    image = test_helper.image_factory.create(image2_def, all_definitions: {
      image1: image1_def, image2: image2_def
    })

    expect(subject).to receive(:compile_image).with(shell, image, builds_dir)
    expect(subject).to receive(:compile_image).with(shell, image.dependent_images.first, builds_dir)

    subject.compile(shell, image, builds_dir)
  end
end