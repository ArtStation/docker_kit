RSpec.describe KuberKit::EnvFileReader::EnvFileTempfileCreator do
  subject{ KuberKit::EnvFileReader::EnvFileTempfileCreator.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:env_files).setup(File.join(FIXTURES_PATH, "env_files")) }
  let(:env_file_erb) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test2.env.erb") }

  before do
    test_helper.artifact_store.add(artifact)
  end

  it "returns path to the temp env file" do
    result = subject.call(test_helper.shell, env_file_erb)
    expect(result).to match(/env_files\/env_files-test_env/)
  end

  it "produces env file with compiled content" do
    file_path = subject.call(test_helper.shell, env_file_erb)
    content   = File.read(file_path)
    expect(content).to eq("RUBY_ENV=review\r\nAPP_NAME=KuberKit")
  end
end