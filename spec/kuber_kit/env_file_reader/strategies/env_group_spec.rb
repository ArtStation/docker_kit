RSpec.describe KuberKit::EnvFileReader::Strategies::EnvGroup do
  subject{ KuberKit::EnvFileReader::Strategies::EnvGroup.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:env_files).setup(File.join(FIXTURES_PATH, "env_files")) }

  let(:env_file_1) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env1, artifact_name: :env_files, file_path: "test.env") }
  let(:env_file_2) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env2, artifact_name: :env_files, file_path: "patch.env") }
  let(:env_group_1) { KuberKit::Core::EnvFiles::EnvGroup.new(:test_group_1, env_files: [:test_env1, :test_env2]) }
  let(:env_group_2) { KuberKit::Core::EnvFiles::EnvGroup.new(:test_group_2, env_files: [:test_env1, :test_group_1]) }

  before do
    test_helper.env_file_store.add(env_file_1)
    test_helper.env_file_store.add(env_file_2)
    test_helper.env_file_store.add(env_group_1)
    test_helper.artifact_store.add(artifact)
  end

  it "returns merged content of the env files" do
    result = subject.read(test_helper.shell, env_group_1)
    expect(result).to eq({
      "RUBY_ENV"      => "review",
      "APP_NAME"      => "KuberKit Patched",
      "ENABLED"       => "true",
      "TITLE"         => "KuberKit==Good",
      "ITEMS_COUNT"   => "5",
      "ERB_TEXT"      => '<%= "KuberKit" %>',
      "PATCH_VERSION" => "1"
    })
  end

  it "doesn't allow using another group inside the group" do
    expect{ subject.read(test_helper.shell, env_group_2) }.to raise_error(/not supported/)
  end
end