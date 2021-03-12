RSpec.describe KuberKit::ImageCompiler::ImageDependencyResolver do
  subject{ KuberKit::ImageCompiler::TestDependencyResolver.new }

  class KuberKit::ImageCompiler::TestDependencyResolver < KuberKit::Core::Dependencies::AbstractDependencyResolver
    include KuberKit::Import[
      "core.image_store",
      "configs"
    ]
    
    def get_deps(image_name)
      image_store.get_definition(image_name).dependencies
    end
  
    def dependency_batch_size
      5
    end
  end

  let!(:imageA) { test_helper.image_store.define(:imageA).depends_on(:imageB) }
  let!(:imageB) { test_helper.image_store.define(:imageB).depends_on(:imageC, :imageD) }
  let!(:imageC) { test_helper.image_store.define(:imageC) }
  let!(:imageD) { test_helper.image_store.define(:imageD) }

  context "#get_deps" do
    it "returns dependencies" do
      expect(subject.get_deps(:imageA)).to eq([:imageB])
    end
  end

  context "#get_recursive_deps" do
    it "returns recursive dependencies" do
      expect(subject.get_recursive_deps(:imageA)).to eq([:imageB, :imageC, :imageD])
    end

    it "raises exception on circular dependency" do
      image1 = test_helper.image_store.define(:image1).depends_on(:image2)
      image2 = test_helper.image_store.define(:image2).depends_on(:image1)

      expect{
        subject.get_recursive_deps(:image1)
      }.to raise_error(KuberKit::ImageCompiler::ImageDependencyResolver::CircularDependencyError)
    end

    it "raises exception if dependency is not found" do
      image1 = test_helper.image_store.define(:image1).depends_on(:image2)

      expect{
        subject.get_recursive_deps(:image1)
      }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end

  context "#get_next" do
    it "resolves dependencies for 1st step" do
      expect(subject.get_next(:imageA)).to eq([:imageC, :imageD])
    end

    it "resolves dependencies for 2nd step" do
      expect(subject.get_next(:imageA, resolved: [:imageC, :imageD])).to eq([:imageB])
    end

    it "resolves dependencies for 3rd step" do
      expect(subject.get_next(:imageA, resolved: [:imageB, :imageC, :imageD])).to eq([])
    end

    it "resolves dependencies for 1st step of array" do
      expect(subject.get_next([:imageA, :imageB])).to eq([:imageC, :imageD])
    end

    it "resolves dependencies for 2nd step of array" do
      expect(subject.get_next([:imageA, :imageB], resolved: [:imageC, :imageD])).to eq([:imageB])
    end

    it "resolves dependencies for 3rd step of array" do
      expect(subject.get_next([:imageA, :imageB], resolved: [:imageC, :imageD, :imageB])).to eq([])
    end

    it "doesn't exceed the limit" do
      test_helper.image_store.define(:image1).depends_on(:image2, :image3, :image4, :image5)
      test_helper.image_store.define(:image2)
      test_helper.image_store.define(:image3)
      test_helper.image_store.define(:image4)
      test_helper.image_store.define(:image5)

      expect(subject.get_next([:image1], resolved: [], limit: 3)).to eq([:image2, :image3, :image4])
      expect(subject.get_next([:image1], resolved: [], limit: 4)).to eq([:image2, :image3, :image4, :image5])
    end

    it "returns empty for independent images" do
      expect(subject.get_next([:imageC, :imageD])).to eq([])
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

    it "applies the limit to final images list as well" do
      test_helper.image_store.define(:image1)
      test_helper.image_store.define(:image2)
      test_helper.image_store.define(:image3)
      test_helper.image_store.define(:image4)
      test_helper.image_store.define(:image5)
      test_helper.image_store.define(:image6)

      callback = Proc.new {}

      expect(callback).to receive(:call).with([:image1, :image2, :image3, :image4, :image5])
      expect(callback).to receive(:call).with([:image6])

      subject.each_with_deps([:image1, :image2, :image3, :image4, :image5, :image6], &callback)
    end
  end
end