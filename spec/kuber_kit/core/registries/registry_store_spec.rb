require 'spec_helper'

RSpec.describe KuberKit::Core::Registries::RegistryStore do
  subject{ KuberKit::Core::Registries::RegistryStore.new }

  it "returns default registry" do
    expect(subject.default_registry).to be_a(KuberKit::Core::Registries::Registry)
  end

  context "#get_global" do
    it "returns global registry" do
      registry = KuberKit::Core::Registries::Registry.new(:default)
      subject.add(registry)

      expect(subject.get_global(:default)).to eq(registry)
    end

    it "raises error if registry is not found" do
      expect{ subject.get_global(:default) }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration registry" do
      registry = KuberKit::Core::Registries::Registry.new(:production_default)
      subject.add(registry)
      test_helper.configuration_store.define(:production).use_registry(:production_default, as: :default)
      KuberKit.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(registry)
    end

    it "returns nil if registry is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end
end