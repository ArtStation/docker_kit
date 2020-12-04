RSpec.describe KuberKit::TemplateReader::Strategies::ArtifactFile do
  subject{ KuberKit::TemplateReader::Strategies::ArtifactFile.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:templates).setup(File.join(FIXTURES_PATH, "templates")) }
  let(:template) { KuberKit::Core::Templates::ArtifactFile.new(:test_template, artifact_name: :templates, file_path: "configuration.yml") }

  before do
    test_helper.artifact_store.add(artifact)
  end

  it "returns preprocessed content of the artifact" do
    result = subject.read(test_helper.shell, template)
    expect(result).to eq("apiVersion: v1\nkind: Service\nmetadata:\n  configuration: \"<%= configuration_name.to_s %>\"\nspec:\n  selector:\n    app: test-app")
  end
end