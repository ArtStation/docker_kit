RSpec.describe Indocker::Actions::ImageCompiler do
  subject{ Indocker::Actions::ImageCompiler.new }

  let(:shell) { test_helper.shell }
  let(:builds_dir) { "/tmp/images" }

  xit "compiles image with dependencies" do
    image1_def = test_helper.image_definition_factory.create(:image1)
    image2_def = test_helper.image_definition_factory.create(:image2).depends_on(:image1)

    expect(subject).to receive(:compile_image).with(shell, :image1, builds_dir)
    expect(subject).to receive(:compile_image).with(shell, :image2, builds_dir)

    subject.call(:image2, builds_dir)
  end
end