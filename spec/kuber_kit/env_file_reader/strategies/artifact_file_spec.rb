RSpec.describe KuberKit::EnvFileReader::Strategies::ArtifactFile do
  subject{ KuberKit::EnvFileReader::Strategies::ArtifactFile.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:env_files).setup(File.join(FIXTURES_PATH, "env_files")) }
  let(:env_file_plain) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test.env") }
  let(:env_file_erb) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env_erb, artifact_name: :env_files, file_path: "test2.env.erb") }

  before do
    test_helper.artifact_store.add(artifact)
  end

  it "returns parsed content of the artifact" do
    result = subject.read(test_helper.shell, env_file_plain)
    expect(result).to eq({
      "RUBY_ENV"    => "review",
      "APP_NAME"    => "KuberKit",
      "ENABLED"     => "true",
      "TITLE"       => "KuberKit==Good",
      "ITEMS_COUNT" => "5",
      "ERB_TEXT"    => '<%= "KuberKit" %>'
    })
  end

  it "processes ERB if file ends with .erb extension" do
    result = subject.read(test_helper.shell, env_file_erb)
    expect(result).to eq({
      "RUBY_ENV"    => "review",
      "APP_NAME"    => "KuberKit"
    })
  end
end