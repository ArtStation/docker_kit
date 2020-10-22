RSpec.describe Indocker::EnvFileReader::AbstractEnvFileReader do
  subject{ Indocker::EnvFileReader::AbstractEnvFileReader.new }

  let(:env_file) { Indocker::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test.env") }

  it "returns content of the artifact" do
    expect{ subject.read(test_helper.shell, env_file) }.to raise_error(Indocker::NotImplementedError)
  end
end