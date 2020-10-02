require 'spec_helper'

RSpec.describe Indocker::Core::InfraStore do
  subject{ Indocker::Core::InfraStore.new }

  it "returns default registry" do
    expect(subject.default_registry).to be_a(Indocker::Core::Registry)
  end

  context "#get_global_registry" do
    it "returns global registry" do
      registry = Indocker::Core::Registry.new(:default)
      subject.add_registry(registry)

      expect(subject.get_global_registry(:default)).to eq(registry)
    end

    it "raises error if registry is not found" do
      expect{ subject.get_global_registry(:default) }.to raise_error(Indocker::Core::InfraStore::NotFoundError)
    end
  end

  context "#get_configuration_registry" do
    it "returns configuration registry" do
      registry = Indocker::Core::Registry.new(:production_default)
      subject.add_registry(registry)
      test_helper.configuration_store.define(:production).use_registry(:production_default, as: :default)
      Indocker.set_configuration_name(:production)

      expect(subject.get_configuration_registry(:default)).to eq(registry)
    end

    it "returns nil if registry is not found" do
      expect(subject.get_configuration_registry(:default)).to be_nil
    end
  end

  context "#add_registry" do
    it "doesn't allow adding registry twice" do
      registry = Indocker::Core::Registry.new(:default)
      subject.add_registry(registry)

      expect{ subject.add_registry(registry) }.to raise_error(Indocker::Core::InfraStore::AlreadyAddedError)
    end

    it "doesn't allow adding not registry class" do
      expect{ subject.add_registry(12) }.to raise_error(ArgumentError)
    end
  end
end