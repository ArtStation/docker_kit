RSpec.describe KuberKit::Actions::ImageCompiler do
  subject{ KuberKit::Actions::ImageCompiler.new }

  let(:shell) { test_helper.shell }

  before do
    allow(subject).to receive(:generate_build_id).and_return("200320")
  end

  it "compiles image with dependencies" do
    image1_def = test_helper.image_store.define(:image1)
    image2_def = test_helper.image_store.define(:image2).depends_on(:image1)
    image3_def = test_helper.image_store.define(:image3).depends_on(:image2)

    expect(subject.image_compiler).to receive(:call).with(kind_of(KuberKit::Shell::AbstractShell), :image1, "200320") { sleep(0.01) }
    expect(subject.image_compiler).to receive(:call).with(kind_of(KuberKit::Shell::AbstractShell), :image2, "200320") { sleep(0.01) }
    expect(subject.image_compiler).to receive(:call).with(kind_of(KuberKit::Shell::AbstractShell), :image3, "200320") { sleep(0.01) }

    subject.call([:image3], {})
  end
end