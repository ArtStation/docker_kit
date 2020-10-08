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

  context "artifact" do
    it "saves artifacts as hash" do
      subject.use_artifact(:main_production_repo, as: :main_repo)

      expect(subject.to_attrs.artifacts).to eq({main_repo: :main_production_repo})
    end

    it "doesn't allow duplicates" do
      subject.use_artifact(:main_production_repo, as: :main_repo)
      expect{
        subject.use_artifact(:main_production_repo, as: :main_repo)
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