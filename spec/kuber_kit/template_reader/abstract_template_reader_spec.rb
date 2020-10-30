RSpec.describe KuberKit::TemplateReader::AbstractTemplateReader do
  subject{ KuberKit::TemplateReader::AbstractTemplateReader.new }

  let(:env_file) { KuberKit::Core::Templates::ArtifactFile.new(:test_template, artifact_name: :env_files, file_path: "test.erb") }

  it do
    expect{ subject.read(test_helper.shell, env_file) }.to raise_error(KuberKit::NotImplementedError)
  end
end