RSpec.describe DockerKit::Preprocessing::DirPreprocessor do
  subject{ DockerKit::Preprocessing::DirPreprocessor.new }

  let(:context_helper) { test_helper.context_helper }
  let(:shell) { test_helper.shell }

  let(:source_dir) { File.join(FIXTURES_PATH, "compiler") }
  let(:destination_dir) { File.join(FIXTURES_PATH, "tmp") }

  after do 
    FileUtils.rm_r(destination_dir) if File.exists?(destination_dir)
  end

  it "compiles all files in directory" do
    expect(shell).to receive(:recursive_list_files).and_return([
      File.join(source_dir, "erb_template.txt"),
      File.join(source_dir, "config/test.cfg")
    ])

    expect(subject.file_preprocessor).to receive(:compile).with(
      shell, File.join(source_dir, "erb_template.txt"), 
      destination_path: File.join(destination_dir, "erb_template.txt"),
      context_helper: context_helper
    )
    expect(subject.file_preprocessor).to receive(:compile).with(
      shell, File.join(source_dir, "config/test.cfg"),
      destination_path: File.join(destination_dir, "config/test.cfg"),
      context_helper: context_helper
    )

    subject.compile(shell, source_dir, destination_dir, context_helper: context_helper)
  end
end