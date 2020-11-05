require 'spec_helper'

RSpec.describe KuberKit::Core::EnvFiles::EnvFileStore do
  subject{ KuberKit::Core::EnvFiles::EnvFileStore.new }

  context "#get_global" do
    it "returns global env_file" do
      env_file = KuberKit::Core::EnvFiles::ArtifactFile.new(:default, artifact_name: :env_files, file_path: "path/to.file")
      subject.add(env_file)

      expect(subject.get_global(:default)).to eq(env_file)
    end

    it "raises error if env_file is not found" do
      expect{ subject.get_global(:default) }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration env_file" do
      env_file = KuberKit::Core::EnvFiles::ArtifactFile.new(:production_default, artifact_name: :env_files, file_path: "path/to.file")
      subject.add(env_file)
      test_helper.configuration_store.define(:production).use_env_file(:production_default, as: :default)
      KuberKit.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(env_file)
    end

    it "returns nil if env_file is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end
end