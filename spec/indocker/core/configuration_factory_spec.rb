require 'spec_helper'

RSpec.describe Indocker::Core::ConfigurationFactory do
  subject{ Indocker::Core::ConfigurationFactory.new() }
  let(:configuration_definition_factory) { test_helper.configuration_definition_factory }
  let(:test_definition) { configuration_definition_factory.create(:production) }

  it "builds configuration based on configuration definition" do
    image = subject.create(test_definition)

    expect(image).to be_a(Indocker::Core::Configuration)
    expect(image.name).to eq(:production)
  end

  it "sets registries from definition" do
    test_helper.add_registry(:main_production_registry, "http://example.com")

    definition = test_definition.use_registry(:main_production_registry, as: :main_registry)
    configuration = subject.create(definition)

    expect(configuration.registries[:main_registry]).to be_a(Indocker::Core::Registries::Registry)
  end

  it "raises exception if registry is not found" do
    definition = test_definition.use_registry(:main_production_registry, as: :main_registry)

    expect{ subject.create(definition) }.to raise_error(Indocker::Core::Registries::RegistryStore::NotFoundError)
  end

  it "sets repositories from definition" do
    test_helper.add_repository(:main_production_repo, "git@example.com/myapp.git")

    definition = test_definition.use_repository(:main_production_repo, as: :main_repo)
    configuration = subject.create(definition)

    expect(configuration.repositories[:main_repo]).to be_a(Indocker::Core::Repositories::Git)
  end

  it "raises exception if repository is not found" do
    definition = test_definition.use_repository(:main_production_repo, as: :main_repo)

    expect{ subject.create(definition) }.to raise_error(Indocker::Core::Repositories::RepositoryStore::NotFoundError)
  end
end