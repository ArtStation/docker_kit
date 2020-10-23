RSpec.describe Indocker::EnvFileReader::ArtifactFileReader do
  subject{ Indocker::EnvFileReader::ArtifactFileReader.new }

  let(:artifact) { Indocker::Core::Artifacts::Local.new(:env_files).setup(File.join(FIXTURES_PATH, "env_files")) }
  let(:env_file) { Indocker::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test.env") }

  before do
    test_helper.artifact_store.add(artifact)
  end

  it "returns parsed content of the artifact" do
    result = subject.read(test_helper.shell, env_file)
    expect(result).to eq({
      "RUBY_ENV"    => "review",
      "APP_NAME"    => "Indocker",
      "ENABLED"     => "true",
      "TITLE"       => "Indocker==Good",
      "ITEMS_COUNT" => "5"
    })
  end
end