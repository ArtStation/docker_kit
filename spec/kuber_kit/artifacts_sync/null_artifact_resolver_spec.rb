RSpec.describe KuberKit::ArtifactsSync::NullArtifactResolver do
  subject{ KuberKit::ArtifactsSync::NullArtifactResolver.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:myapp).setup("/tmp/myappp") }

  it "does nothing" do
    expect(subject.resolve(test_helper.shell, artifact)).to be(true)
  end
end