RSpec.describe KuberKit::ImageCompiler::ImageDependencyResolver do
  subject{ KuberKit::ImageCompiler::ImageDependencyResolver.new }

  let!(:imageA) { test_helper.image_store.define(:imageA).depends_on(:imageB) }
  let!(:imageB) { test_helper.image_store.define(:imageB).depends_on(:imageC, :imageD) }
  let!(:imageC) { test_helper.image_store.define(:imageC) }
  let!(:imageD) { test_helper.image_store.define(:imageD) }

  context "#get_deps" do
    it "returns image dependencies" do
      expect(subject.get_deps(:imageA)).to eq([:imageB])
    end
  end

  context "#each_with_deps" do
    it "iterates over dependencies and image itself" do
      test_helper.image_store.define(:image1)
      test_helper.image_store.define(:image2_a).depends_on(:image1)
      test_helper.image_store.define(:image2_b).depends_on(:image1)
      test_helper.image_store.define(:image3_a).depends_on(:image2_a)
      test_helper.image_store.define(:image3_b).depends_on(:image2_b, :image1)
      test_helper.image_store.define(:image4).depends_on(:image1, :image3_a, :image3_b)

      callback = Proc.new {}

      expect(callback).to receive(:call).with([:image1])
      expect(callback).to receive(:call).with([:image2_a, :image2_b])
      expect(callback).to receive(:call).with([:image3_a, :image3_b])
      expect(callback).to receive(:call).with([:image4])

      subject.each_with_deps([:image4], &callback)
    end
  end
end