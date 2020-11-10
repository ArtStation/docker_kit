RSpec.describe KuberKit::Core::BuildServers::AbstractBuildServer do
  subject { KuberKit::Core::BuildServers::AbstractBuildServer.new(:default) }

  it do
    expect{ subject.host }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.port }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.user }.to raise_error(KuberKit::NotImplementedError)
  end
end