RSpec.describe Indocker::ArtifactsSync::AbstractArtifactResolver do
  subject{ Indocker::ArtifactsSync::AbstractArtifactResolver.new }

  let(:artifact) { Indocker::Core::Artifacts::Local.new(:myapp).setup("/tmp/myappp") }

  it do
    expect{ subject.resolve(test_helper.shell, artifact) }.to raise_error(Indocker::NotImplementedError)
  end
end