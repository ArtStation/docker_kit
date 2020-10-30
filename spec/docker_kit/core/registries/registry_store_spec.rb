require 'spec_helper'

RSpec.describe DockerKit::Core::Registries::RegistryStore do
  subject{ DockerKit::Core::Registries::RegistryStore.new }

  it "returns default registry" do
    expect(subject.default_registry).to be_a(DockerKit::Core::Registries::Registry)
  end

  context "#get_global" do
    it "returns global registry" do
      registry = DockerKit::Core::Registries::Registry.new(:default)
      subject.add(registry)

      expect(subject.get_global(:default)).to eq(registry)
    end

    it "raises error if registry is not found" do
      expect{ subject.get_global(:default) }.to raise_error(DockerKit::Core::Registries::RegistryStore::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration registry" do
      registry = DockerKit::Core::Registries::Registry.new(:production_default)
      subject.add(registry)
      test_helper.configuration_store.define(:production).use_registry(:production_default, as: :default)
      DockerKit.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(registry)
    end

    it "returns nil if registry is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end

  context "#add" do
    it "doesn't allow adding registry twice" do
      registry = DockerKit::Core::Registries::Registry.new(:default)
      subject.add(registry)

      expect{ subject.add(registry) }.to raise_error(DockerKit::Core::Registries::RegistryStore::AlreadyAddedError)
    end

    it "doesn't allow adding not registry class" do
      expect{ subject.add(12) }.to raise_error(ArgumentError)
    end
  end
end