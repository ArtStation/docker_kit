RSpec.describe DockerKit::Core::Registries::AbstractRegistry do
  subject { DockerKit::Core::Registries::AbstractRegistry.new(:default) }

  it do
    expect{ subject.path }.to raise_error(DockerKit::NotImplementedError)
  end

  it do
    expect{ subject.remote_path }.to raise_error(DockerKit::NotImplementedError)
  end

  it do
    expect{ subject.remote? }.to raise_error(DockerKit::NotImplementedError)
  end

  it do
    expect{ subject.local? }.to raise_error(DockerKit::NotImplementedError)
  end
end
