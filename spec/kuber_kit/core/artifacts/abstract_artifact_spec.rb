RSpec.describe KuberKit::Core::Registries::AbstractRegistry do
  subject { KuberKit::Core::Artifacts::AbstractArtifact.new(:default) }

  it do
    expect{ subject.namespace }.to raise_error(KuberKit::NotImplementedError)
  end
end
