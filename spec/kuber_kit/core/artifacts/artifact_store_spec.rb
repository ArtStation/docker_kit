require 'spec_helper'

RSpec.describe KuberKit::Core::Artifacts::ArtifactStore do
  subject{ KuberKit::Core::Artifacts::ArtifactStore.new }

  context "#get_global" do
    it "returns global artifact" do
      artifact = KuberKit::Core::Artifacts::Git.new(:default)
      subject.add(artifact)

      expect(subject.get_global(:default)).to eq(artifact)
    end

    it "raises error if artifact is not found" do
      expect{ subject.get_global(:default) }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration artifact" do
      artifact = KuberKit::Core::Artifacts::Git.new(:production_default)
      subject.add(artifact)
      test_helper.configuration_store.define(:production).use_artifact(:production_default, as: :default)
      KuberKit.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(artifact)
    end

    it "returns nil if artifact is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end
end