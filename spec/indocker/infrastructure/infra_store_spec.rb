require 'spec_helper'

RSpec.describe Indocker::Core::InfraStore do
  subject{ Indocker::Core::InfraStore.new }

  context "#get_registry" do
    it "returns previously added registry" do
      registry = Indocker::Core::Registry.new(:default)
      subject.add_registry(registry)

      expect(subject.get_registry(:default)).to eq(registry)
    end

    it "raises error if registry is not found" do
      expect{ subject.get_registry(:default) }.to raise_error(Indocker::Core::InfraStore::NotFoundError)
    end

    it "returns default registry" do
      expect(subject.default_registry).to be_a(Indocker::Core::Registry)
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