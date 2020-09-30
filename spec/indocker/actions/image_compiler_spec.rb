RSpec.describe Indocker::Actions::ImageCompiler do
  subject{ Indocker::Actions::ImageCompiler.new }

  let(:shell) { test_helper.shell }

  before do
    allow(subject).to receive(:generate_build_id).and_return("200320")
  end

  it "compiles image with dependencies" do
    image1_def = test_helper.image_store.define(:image1)
    image2_def = test_helper.image_store.define(:image2).depends_on(:image1)
    image3_def = test_helper.image_store.define(:image3).depends_on(:image2)

    expect(subject).to receive(:compile_image).with(:image1, "200320")
    expect(subject).to receive(:compile_image).with(:image2, "200320")
    expect(subject).to receive(:compile_image).with(:image3, "200320")

    subject.call([:image3], {})
  end

  it "compiles image simultaneously when possible" do
    image1_def = test_helper.image_store.define(:image1)
    image2_def = test_helper.image_store.define(:image2_a).depends_on(:image1)
    image2_def = test_helper.image_store.define(:image2_b).depends_on(:image1)
    image2_def = test_helper.image_store.define(:image3_a).depends_on(:image2_a)
    image2_def = test_helper.image_store.define(:image3_b).depends_on(:image2_b, :image1)
    image3_def = test_helper.image_store.define(:image4).depends_on(:image1, :image3_a, :image3_b)

    expect(subject).to receive(:compile_simultaneously).with([:image1], "200320")
    expect(subject).to receive(:compile_simultaneously).with([:image2_a, :image2_b], "200320")
    expect(subject).to receive(:compile_simultaneously).with([:image3_a, :image3_b], "200320")
    expect(subject).to receive(:compile_simultaneously).with([:image4], "200320")

    subject.call([:image4], {})
  end
end