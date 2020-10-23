RSpec.describe Indocker::ImageCompiler::VersionTagBuilder do
  subject { Indocker::ImageCompiler::VersionTagBuilder.new }

  context "get_version" do
    it "returns tag with current date and time" do
      version = subject.get_version

      expect(version).to match(/20[0-9]{6}\.[0-9]{6}/)
    end
  end
end