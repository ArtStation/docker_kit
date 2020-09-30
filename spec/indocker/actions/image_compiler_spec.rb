RSpec.describe Indocker::Actions::ImageCompiler do
  subject{ Indocker::Actions::ImageCompiler.new }

  let(:shell) { test_helper.shell }

  it "compiles image with dependencies" do
    image1_def = test_helper.image_store.define(:image1)
    image2_def = test_helper.image_store.define(:image2).depends_on(:image1)
    image3_def = test_helper.image_store.define(:image3).depends_on(:image2)

    expect(subject).to receive(:compile_image).with(:image1)
    expect(subject).to receive(:compile_image).with(:image2)
    expect(subject).to receive(:compile_image).with(:image3)

    subject.call(:image3, {})
  end
end