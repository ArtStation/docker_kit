RSpec.describe Indocker::TemplateReader::ArtifactFileReader do
  subject{ Indocker::TemplateReader::ArtifactFileReader.new }

  let(:artifact) { Indocker::Core::Artifacts::Local.new(:templates).setup(File.join(FIXTURES_PATH, "templates")) }
  let(:template) { Indocker::Core::Templates::ArtifactFile.new(:test_template, artifact_name: :templates, file_path: "service.yml") }

  before do
    test_helper.artifact_store.add(artifact)
  end

  it "returns preprocessed content of the artifact" do
    result = subject.read(test_helper.shell, template, context_helper: test_helper.context_helper)
    expect(result).to eq("apiVersion: v1\nkind: Service\nmetadata:\n  configuration: \"default\"\nspec:\n  selector:\n    app: test-app")
  end
end