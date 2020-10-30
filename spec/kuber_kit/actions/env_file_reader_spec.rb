RSpec.describe KuberKit::Actions::EnvFileReader do
  subject{ KuberKit::Actions::EnvFileReader.new }

  let(:shell) { test_helper.shell }
  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:env_files).setup(File.join(FIXTURES_PATH, "env_files")) }
  let(:env_file) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test.env") }

  before do
    test_helper.artifact_store.add(artifact)
    test_helper.env_file_store.add(env_file)
  end

  it "prints content of env file" do
    expect(subject.ui).to receive(:print_info).with("test_env", /RUBY_ENV/)
    subject.call(:test_env, {})
  end
end