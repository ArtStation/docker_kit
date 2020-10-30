RSpec.describe DockerKit::EnvFileReader::AbstractEnvFileReader do
  subject{ DockerKit::EnvFileReader::AbstractEnvFileReader.new }

  let(:env_file) { DockerKit::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test.env") }

  it do
    expect{ subject.read(test_helper.shell, env_file) }.to raise_error(DockerKit::NotImplementedError)
  end
end