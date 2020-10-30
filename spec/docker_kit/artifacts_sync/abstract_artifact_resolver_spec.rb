RSpec.describe DockerKit::ArtifactsSync::AbstractArtifactResolver do
  subject{ DockerKit::ArtifactsSync::AbstractArtifactResolver.new }

  let(:artifact) { DockerKit::Core::Artifacts::Local.new(:myapp).setup("/tmp/myappp") }

  it do
    expect{ subject.resolve(test_helper.shell, artifact) }.to raise_error(DockerKit::NotImplementedError)
  end
end