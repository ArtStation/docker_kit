RSpec.describe Indocker::Core::Registries::AbstractRegistry do
  subject { Indocker::Core::Registries::AbstractRegistry.new(:default) }

  it do
    expect{ subject.path }.to raise_error(Indocker::NotImplementedError)
  end

  it do
    expect{ subject.remote_path }.to raise_error(Indocker::NotImplementedError)
  end

  it do
    expect{ subject.remote? }.to raise_error(Indocker::NotImplementedError)
  end

  it do
    expect{ subject.local? }.to raise_error(Indocker::NotImplementedError)
  end
end
