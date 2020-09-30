RSpec.describe Indocker::Compiler::ImageDependencyResolver do
  subject{ Indocker::Compiler::ImageDependencyResolver.new }

  let(:imageA) { test_helper.image_definition(:imageA).depends_on(:imageB) }
  let(:imageB) { test_helper.image_definition(:imageB).depends_on(:imageC, :imageD) }
  let(:imageC) { test_helper.image_definition(:imageC) }
  let(:imageD) { test_helper.image_definition(:imageD) }
  let(:imageE) { test_helper.image_definition(:imageE) }
  let(:allImages) { index_by([imageA, imageB, imageD, imageC, imageD, imageE], &:image_name) }

  context "#get_deps" do
    it "returns dependencies" do
      expect(subject.get_deps(imageA, all_definitions: allImages)).to eq([imageB])
    end
  end

  context "#get_recursive_deps" do
    it "returns recursive dependencies" do
      expect(subject.get_recursive_deps(imageA, all_definitions: allImages)).to eq([imageB, imageC, imageD])
    end

    it "raises exception on circular dependency" do
      image1 = test_helper.image_definition(:image1).depends_on(:image2)
      image2 = test_helper.image_definition(:image2).depends_on(:image1)

      expect{
        subject.get_recursive_deps(image1, all_definitions: index_by([image1, image2], &:image_name))
      }.to raise_error(Indocker::Compiler::ImageDependencyResolver::CircularDependencyError)
    end

    it "raises exception if dependency is not found" do
      image1 = test_helper.image_definition(:image1).depends_on(:image2)

      expect{
        subject.get_recursive_deps(image1, all_definitions: index_by([image1], &:image_name))
      }.to raise_error(Indocker::Compiler::ImageDependencyResolver::DependencyNotFoundError)
    end
  end

  context "#get_next" do
    it "resolves dependencies for 1st step" do
      expect(subject.get_next(imageA, all_definitions: allImages)).to eq([imageC, imageD])
    end

    it "resolves dependencies for 2nd step" do
      expect(subject.get_next(imageA, all_definitions: allImages, resolved: [imageC, imageD])).to eq([imageB])
    end

    it "resolves dependencies for 3rd step" do
      expect(subject.get_next(imageA, all_definitions: allImages, resolved: [imageB, imageC, imageD])).to eq([])
    end
  end
end