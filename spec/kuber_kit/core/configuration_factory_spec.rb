require 'spec_helper'

RSpec.describe KuberKit::Core::ConfigurationFactory do
  subject{ KuberKit::Core::ConfigurationFactory.new() }
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

    expect(configuration.registries[:main_registry]).to be_a(KuberKit::Core::Registries::Registry)
  end

  it "raises exception if registry is not found" do
    definition = test_definition.use_registry(:main_production_registry, as: :main_registry)

    expect{ subject.create(definition) }.to raise_error(KuberKit::Core::Store::NotFoundError)
  end

  it "sets artifacts from definition" do
    test_helper.add_artifact(:main_production_repo, "git@example.com/myapp.git")

    definition = test_definition.use_artifact(:main_production_repo, as: :main_repo)
    configuration = subject.create(definition)

    expect(configuration.artifacts[:main_repo]).to be_a(KuberKit::Core::Artifacts::Git)
  end

  it "sets build servers from definition" do
    test_helper.add_build_server(:main_server)

    definition = test_definition.use_build_server(:main_server)
    configuration = subject.create(definition)

    expect(configuration.build_servers.first).to be_a(KuberKit::Core::BuildServers::BuildServer)
  end

  it "raises exception if artifact is not found" do
    definition = test_definition.use_artifact(:main_production_repo, as: :main_repo)

    expect{ subject.create(definition) }.to raise_error(KuberKit::Core::Store::NotFoundError)
  end
end