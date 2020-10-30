RSpec.describe DockerKit::Core::Registries::AbstractRegistry do
  subject { DockerKit::Core::Artifacts::AbstractArtifact.new(:default) }

  it do
    expect{ subject.namespace }.to raise_error(DockerKit::NotImplementedError)
  end
end
