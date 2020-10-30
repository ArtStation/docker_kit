RSpec.describe DockerKit::ArtifactsSync::NullArtifactResolver do
  subject{ DockerKit::ArtifactsSync::NullArtifactResolver.new }

  let(:artifact) { DockerKit::Core::Artifacts::Local.new(:myapp).setup("/tmp/myappp") }

  it "does nothing" do
    expect(subject.resolve(test_helper.shell, artifact)).to be(true)
  end
end