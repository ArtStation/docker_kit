RSpec.describe KuberKit::EnvFileReader::Strategies::Abstract do
  subject{ KuberKit::EnvFileReader::Strategies::Abstract.new }

  let(:env_file) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test.env") }

  it do
    expect{ subject.read(test_helper.shell, env_file) }.to raise_error(KuberKit::NotImplementedError)
  end
end