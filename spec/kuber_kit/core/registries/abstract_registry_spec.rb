RSpec.describe KuberKit::Core::Registries::AbstractRegistry do
  subject { KuberKit::Core::Registries::AbstractRegistry.new(:default) }

  it do
    expect{ subject.path }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.remote_path }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.remote? }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.local? }.to raise_error(KuberKit::NotImplementedError)
  end
end
