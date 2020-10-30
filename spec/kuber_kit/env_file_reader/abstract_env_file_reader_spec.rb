RSpec.describe KuberKit::EnvFileReader::AbstractEnvFileReader do
  subject{ KuberKit::EnvFileReader::AbstractEnvFileReader.new }

  let(:env_file) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test.env") }

  it do
    expect{ subject.read(test_helper.shell, env_file) }.to raise_error(KuberKit::NotImplementedError)
  end
end