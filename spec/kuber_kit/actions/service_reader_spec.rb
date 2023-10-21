RSpec.describe KuberKit::Actions::ServiceReader do
  subject{ KuberKit::Actions::ServiceReader.new }

  let(:shell) { test_helper.shell }
  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:templates).setup(File.join(FIXTURES_PATH, "templates")) }
  let(:service_template) { KuberKit::Core::Templates::ArtifactFile.new(:service, artifact_name: :templates, file_path: "service.yml") }
  let(:metadata_template) { KuberKit::Core::Templates::ArtifactFile.new(:_metadata, artifact_name: :templates, file_path: "_metadata.yml") }

  before do
    test_helper.artifact_store.add(artifact)
    test_helper.template_store.add(service_template)
    test_helper.template_store.add(metadata_template)

    service_helper.store.define(:auth_app).template(:service)
  end

  it "prints content of service config" do
    expect(subject.ui).to receive(:print_info).with("auth_app", /apiVersion: v1/)
    subject.call(:auth_app, {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.service_reader).to receive(:call).and_raise(KuberKit::Error.new("Some error"))
    subject.call(:auth_app, {})
  end
end