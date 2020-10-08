RSpec.describe Indocker::Core::Registries::AbstractRegistry do
  subject { Indocker::Core::Artifacts::AbstractArtifact.new(:default) }

  it do
    expect{ subject.namespace }.to raise_error(Indocker::NotImplementedError)
  end
end
