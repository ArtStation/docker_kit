RSpec.describe KuberKit::Actions::TemplateReader do
  subject{ KuberKit::Actions::TemplateReader.new }

  let(:shell) { test_helper.shell }
  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:templates).setup(File.join(FIXTURES_PATH, "templates")) }
  let(:template) { KuberKit::Core::Templates::ArtifactFile.new(:test_template, artifact_name: :templates, file_path: "configuration.yml") }

  before do
    test_helper.artifact_store.add(artifact)
    test_helper.template_store.add(template)
  end

  it "prints content of template file" do
    expect(subject.ui).to receive(:print_info).with("test_template", /apiVersion: v1/)
    subject.call(:test_template, {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.template_reader).to receive(:call).and_raise(KuberKit::Error.new("Some error"))
    subject.call(:auth_app, {})
  end
end