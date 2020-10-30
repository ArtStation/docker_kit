require 'spec_helper'

RSpec.describe DockerKit::Core::Artifacts::ArtifactStore do
  subject{ DockerKit::Core::Artifacts::ArtifactStore.new }

  context "#get_global" do
    it "returns global artifact" do
      artifact = DockerKit::Core::Artifacts::Git.new(:default)
      subject.add(artifact)

      expect(subject.get_global(:default)).to eq(artifact)
    end

    it "raises error if artifact is not found" do
      expect{ subject.get_global(:default) }.to raise_error(DockerKit::Core::Artifacts::ArtifactStore::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration artifact" do
      artifact = DockerKit::Core::Artifacts::Git.new(:production_default)
      subject.add(artifact)
      test_helper.configuration_store.define(:production).use_artifact(:production_default, as: :default)
      DockerKit.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(artifact)
    end

    it "returns nil if artifact is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end

  context "#add" do
    it "doesn't allow adding artifact twice" do
      artifact = DockerKit::Core::Artifacts::Git.new(:default)
      subject.add(artifact)

      expect{ subject.add(artifact) }.to raise_error(DockerKit::Core::Artifacts::ArtifactStore::AlreadyAddedError)
    end

    it "doesn't allow adding not artifact class" do
      expect{ subject.add(12) }.to raise_error(ArgumentError)
    end
  end
end