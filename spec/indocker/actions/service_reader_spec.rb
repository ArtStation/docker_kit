RSpec.describe Indocker::Actions::ServiceReader do
  subject{ Indocker::Actions::ServiceReader.new }

  let(:shell) { test_helper.shell }
  let(:artifact) { Indocker::Core::Artifacts::Local.new(:templates).setup(File.join(FIXTURES_PATH, "templates")) }
  let(:template) { Indocker::Core::Templates::ArtifactFile.new(:service, artifact_name: :templates, file_path: "service.yml") }

  before do
    test_helper.artifact_store.add(artifact)
    test_helper.template_store.add(template)

    test_helper.service_store.define(:auth_app).template(:service)
  end

  it "prints content of service config" do
    expect(subject.ui).to receive(:print_info).with("auth_app", /apiVersion: v1/)
    subject.call(:auth_app, {})
  end
end