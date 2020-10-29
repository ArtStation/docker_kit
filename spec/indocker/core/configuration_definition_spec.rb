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

  context "env_file" do
    it "saves env_files as hash" do
      subject.use_env_file(:main_production_env_file, as: :main_registry)

      expect(subject.to_attrs.env_files).to eq({main_registry: :main_production_env_file})
    end

    it "doesn't allow duplicates" do
      subject.use_env_file(:main_production_env_file, as: :main_registry)
      expect{
        subject.use_env_file(:main_production_env_file, as: :main_registry)
      }.to raise_error(Indocker::Core::ConfigurationDefinition::ResourceAlreadyAdded)
    end
  end

  context "template" do
    it "saves templates as hash" do
      subject.use_template(:main_production_template, as: :main_registry)

      expect(subject.to_attrs.templates).to eq({main_registry: :main_production_template})
    end

    it "doesn't allow duplicates" do
      subject.use_template(:main_production_template, as: :main_registry)
      expect{
        subject.use_template(:main_production_template, as: :main_registry)
      }.to raise_error(Indocker::Core::ConfigurationDefinition::ResourceAlreadyAdded)
    end
  end

  context "kubecfg" do
    it "sets kubecgf path for confuguration" do
      subject.kubecfg_path("/path/to/kube.cfg")

      expect(subject.to_attrs.kubecfg_path).to eq("/path/to/kube.cfg")
    end
  end
end