RSpec.describe KuberKit::ArtifactsSync::ArtifactsUpdater do
  subject{ KuberKit::ArtifactsSync::ArtifactsUpdater.new }

  class ExampleResolver < KuberKit::ArtifactsSync::AbstractArtifactResolver
    def resolve(shell, artifact)
      resolved_artifacts.push(artifact)
    end

    def resolved_artifacts
      @resolved_artifacts ||= []
    end
  end

  class ExampleArtifact1 < KuberKit::Core::Artifacts::AbstractArtifact
  end

  class ExampleArtifact2 < KuberKit::Core::Artifacts::AbstractArtifact
  end

  let(:resolver1) { ExampleResolver.new }
  let(:resolver2) { ExampleResolver.new }
  let(:artifact1) { ExampleArtifact1.new(:example) }
  let(:artifact2) { ExampleArtifact2.new(:example) }

  it "raises error if resolver not found for class" do
    expect {
      subject.update(test_helper.shell, [artifact1])
    }.to raise_error(KuberKit::ArtifactsSync::ArtifactsUpdater::ResolverNotFoundError)
  end

  it "raises an error if resolver is not instance of abstract resolver" do
    expect {
      subject.use_resolver(KuberKit, artifact_class: ExampleArtifact1)
    }.to raise_error(ArgumentError)
  end

  it "calls the resolver for this artifact on update" do
    subject.use_resolver(resolver1, artifact_class: ExampleArtifact1)
    subject.use_resolver(resolver2, artifact_class: ExampleArtifact2)

    subject.update(test_helper.shell, [artifact1, artifact2])

    expect(resolver1.resolved_artifacts).to include(artifact1)
    expect(resolver2.resolved_artifacts).to include(artifact2)
  end
end