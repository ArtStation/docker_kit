RSpec.describe Indocker::Compiler::ContextHelper do
  subject{ Indocker::Compiler::ContextHelper.new(image_store: test_helper.image_store) }

  context "image_url" do
    it "returns image_url" do
      test_helper.image_store.define(:example)

      expect(subject.image_url(:example)).to eq("default/example:latest")
    end

    it "returns full image_url for remote registry" do
      test_helper.add_registry(:remote, "http://example.com")
      test_helper.image_store.define(:example).registry(:remote)

      expect(subject.image_url(:example)).to eq("http://example.com/remote/example:latest")
    end
  end
end