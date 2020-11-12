RSpec.describe KuberKit::Preprocessing::DirPreprocessor do
  subject{ KuberKit::Preprocessing::DirPreprocessor.new }

  let(:context_helper) { test_helper.context_helper }
  let(:shell) { test_helper.shell }

  let(:source_dir) { File.join(FIXTURES_PATH, "compiler") }
  let(:destination_dir) { File.join(FIXTURES_PATH, "tmp") }

  before do
    allow(shell).to receive(:upload_file)
  end

  after do 
    FileUtils.rm_r(destination_dir) if File.exists?(destination_dir)
  end

  it "compiles all files in directory" do
    expect(subject.local_shell).to receive(:recursive_list_files).and_return([
      File.join(source_dir, "erb_template.txt"),
      File.join(source_dir, "config/test.cfg")
    ])

    expect(shell).to receive(:upload_file).with(
      File.join(source_dir, "erb_template.txt"), File.join(destination_dir, "erb_template.txt")
    )
    expect(shell).to receive(:upload_file).with(
      File.join(source_dir, "config/test.cfg"), File.join(destination_dir, "config/test.cfg")
    )

    expect(subject.file_preprocessor).to receive(:compile).with(
      shell, File.join(destination_dir, "erb_template.txt"), 
      context_helper: context_helper
    )
    expect(subject.file_preprocessor).to receive(:compile).with(
      shell, File.join(destination_dir, "config/test.cfg"),
      context_helper: context_helper
    )

    subject.compile(shell, source_dir, destination_dir, context_helper: context_helper)
  end
end