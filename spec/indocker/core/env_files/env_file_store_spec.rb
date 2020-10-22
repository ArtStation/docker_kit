require 'spec_helper'

RSpec.describe Indocker::Core::EnvFiles::EnvFileStore do
  subject{ Indocker::Core::EnvFiles::EnvFileStore.new }

  context "#get_global" do
    it "returns global env_file" do
      env_file = Indocker::Core::EnvFiles::ArtifactFile.new(:default, "path/to.file")
      subject.add(env_file)

      expect(subject.get_global(:default)).to eq(env_file)
    end

    it "raises error if env_file is not found" do
      expect{ subject.get_global(:default) }.to raise_error(Indocker::Core::EnvFiles::EnvFileStore::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration env_file" do
      env_file = Indocker::Core::EnvFiles::ArtifactFile.new(:production_default, "path/to.file")
      subject.add(env_file)
      test_helper.configuration_store.define(:production).use_env_file(:production_default, as: :default)
      Indocker.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(env_file)
    end

    it "returns nil if env_file is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end

  context "#add" do
    it "doesn't allow adding env_file twice" do
      env_file = Indocker::Core::EnvFiles::ArtifactFile.new(:default, "path/to.file")
      subject.add(env_file)

      expect{ subject.add(env_file) }.to raise_error(Indocker::Core::EnvFiles::EnvFileStore::AlreadyAddedError)
    end

    it "doesn't allow adding not env_file class" do
      expect{ subject.add(12) }.to raise_error(ArgumentError)
    end
  end
end