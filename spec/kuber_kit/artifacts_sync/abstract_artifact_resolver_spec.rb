RSpec.describe KuberKit::ArtifactsSync::AbstractArtifactResolver do
  subject{ KuberKit::ArtifactsSync::AbstractArtifactResolver.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:myapp).setup("/tmp/myappp") }

  it do
    expect{ subject.resolve(test_helper.shell, artifact) }.to raise_error(KuberKit::NotImplementedError)
  end
end