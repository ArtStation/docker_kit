RSpec.describe Indocker::TemplateReader::AbstractTemplateReader do
  subject{ Indocker::TemplateReader::AbstractTemplateReader.new }

  let(:env_file) { Indocker::Core::Templates::ArtifactFile.new(:test_template, artifact_name: :env_files, file_path: "test.erb") }

  it do
    expect{ subject.read(test_helper.shell, env_file) }.to raise_error(Indocker::NotImplementedError)
  end
end