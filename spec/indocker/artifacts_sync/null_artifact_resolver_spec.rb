RSpec.describe Indocker::ArtifactsSync::NullArtifactResolver do
  subject{ Indocker::ArtifactsSync::NullArtifactResolver.new }

  let(:artifact) { Indocker::Core::Artifacts::Local.new(:myapp).setup("/tmp/myappp") }

  it "does nothing" do
    expect(subject.resolve(test_helper.shell, artifact)).to be(true)
  end
end