require 'spec_helper'

RSpec.describe Indocker::Core::ConfigurationDefinition do
  subject{ Indocker::Core::ConfigurationDefinition.new(:production) }

  context "initialize" do
    it "can initialize configuration with symbol name" do
      definition = Indocker::Core::ConfigurationDefinition.new(:production)
      expect(definition.configuration_name).to eq(:production)
    end

    it "can initialize configuration with string name" do
      definition = Indocker::Core::ConfigurationDefinition.new("production")
      expect(definition.configuration_name).to eq(:production)
    end
  end

  context "repository" do
    it "saves repositories as hash" do
      subject.use_repository(:main_production_repo, as: :main_repo)

      expect(subject.to_attrs.repositories).to eq({main_repo: :main_production_repo})
    end

    it "doesn't allow duplicates" do
      subject.use_repository(:main_production_repo, as: :main_repo)
      expect{
        subject.use_repository(:main_production_repo, as: :main_repo)
      }.to raise_error(Indocker::Core::ConfigurationDefinition::ResourceAlreadyAdded)
    end
  end

  context "registry" do
    it "saves registries as hash" do
      subject.use_registry(:main_production_registry, as: :main_registry)

      expect(subject.to_attrs.registries).to eq({main_registry: :main_production_registry})
    end

    it "doesn't allow duplicates" do
      subject.use_registry(:main_production_registry, as: :main_registry)
      expect{
        subject.use_registry(:main_production_registry, as: :main_registry)
      }.to raise_error(Indocker::Core::ConfigurationDefinition::ResourceAlreadyAdded)
    end
  end
end