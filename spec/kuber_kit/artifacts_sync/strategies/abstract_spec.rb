RSpec.describe KuberKit::ArtifactsSync::Strategies::Abstract do
  subject{ KuberKit::ArtifactsSync::Strategies::Abstract.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:myapp).setup("/tmp/myappp") }

  it do
    expect{ subject.update(test_helper.shell, artifact) }.to raise_error(KuberKit::NotImplementedError)
  end
end