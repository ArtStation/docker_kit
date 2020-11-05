require 'spec_helper'

RSpec.describe KuberKit::Core::Templates::TemplateStore do
  subject{ KuberKit::Core::Templates::TemplateStore.new }

  context "#get_global" do
    it "returns global template" do
      template = KuberKit::Core::Templates::ArtifactFile.new(:default, artifact_name: :env_files, file_path: "path/to.file")
      subject.add(template)

      expect(subject.get_global(:default)).to eq(template)
    end

    it "raises error if template is not found" do
      expect{ subject.get_global(:default) }.to raise_error(KuberKit::Core::Store::NotFoundError)
    end
  end

  context "#get_from_configuration" do
    it "returns configuration template" do
      template = KuberKit::Core::Templates::ArtifactFile.new(:production_default, artifact_name: :env_files, file_path: "path/to.file")
      subject.add(template)
      test_helper.configuration_store.define(:production).use_template(:production_default, as: :default)
      KuberKit.set_configuration_name(:production)

      expect(subject.get_from_configuration(:default)).to eq(template)
    end

    it "returns nil if template is not found" do
      expect(subject.get_from_configuration(:default)).to be_nil
    end
  end
end