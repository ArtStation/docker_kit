RSpec.describe DockerKit::TemplateReader::AbstractTemplateReader do
  subject{ DockerKit::TemplateReader::AbstractTemplateReader.new }

  let(:env_file) { DockerKit::Core::Templates::ArtifactFile.new(:test_template, artifact_name: :env_files, file_path: "test.erb") }

  it do
    expect{ subject.read(test_helper.shell, env_file) }.to raise_error(DockerKit::NotImplementedError)
  end
end