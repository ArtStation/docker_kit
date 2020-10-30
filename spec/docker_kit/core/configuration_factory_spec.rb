require 'spec_helper'

RSpec.describe DockerKit::Core::ConfigurationFactory do
  subject{ DockerKit::Core::ConfigurationFactory.new() }
  let(:configuration_definition_factory) { test_helper.configuration_definition_factory }
  let(:test_definition) { configuration_definition_factory.create(:production) }

  it "builds configuration based on configuration definition" do
    image = subject.create(test_definition)

    expect(image.name).to eq(:production)
  end

  it "sets registries from definition" do
    test_helper.add_registry(:main_production_registry, "http://example.com")

    definition = test_definition.use_registry(:main_production_registry, as: :main_registry)
    configuration = subject.create(definition)

    expect(configuration.registries[:main_registry]).to be_a(DockerKit::Core::Registries::Registry)
  end

  it "raises exception if registry is not found" do
    definition = test_definition.use_registry(:main_production_registry, as: :main_registry)

    expect{ subject.create(definition) }.to raise_error(DockerKit::Core::Registries::RegistryStore::NotFoundError)
  end

  it "sets artifacts from definition" do
    test_helper.add_artifact(:main_production_repo, "git@example.com/myapp.git")

    definition = test_definition.use_artifact(:main_production_repo, as: :main_repo)
    configuration = subject.create(definition)

    expect(configuration.artifacts[:main_repo]).to be_a(DockerKit::Core::Artifacts::Git)
  end

  it "raises exception if artifact is not found" do
    definition = test_definition.use_artifact(:main_production_repo, as: :main_repo)

    expect{ subject.create(definition) }.to raise_error(DockerKit::Core::Artifacts::ArtifactStore::NotFoundError)
  end
end