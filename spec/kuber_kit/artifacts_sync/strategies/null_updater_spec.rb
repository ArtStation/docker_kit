RSpec.describe KuberKit::ArtifactsSync::Strategies::NullUpdater do
  subject{ KuberKit::ArtifactsSync::Strategies::NullUpdater.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:myapp).setup("/tmp/myappp") }

  it "does nothing" do
    expect(subject.update(test_helper.shell, artifact)).to be(true)
  end
end