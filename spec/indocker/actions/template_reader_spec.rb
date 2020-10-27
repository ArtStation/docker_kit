RSpec.describe Indocker::Actions::TemplateReader do
  subject{ Indocker::Actions::TemplateReader.new }

  let(:shell) { test_helper.shell }
  let(:artifact) { Indocker::Core::Artifacts::Local.new(:templates).setup(File.join(FIXTURES_PATH, "templates")) }
  let(:template) { Indocker::Core::Templates::ArtifactFile.new(:test_template, artifact_name: :templates, file_path: "configuration.yml") }

  before do
    test_helper.artifact_store.add(artifact)
    test_helper.template_store.add(template)
  end

  it "prints content of template file" do
    expect(subject.ui).to receive(:print_info).with("test_template", /apiVersion: v1/)
    subject.call(:test_template, {})
  end
end