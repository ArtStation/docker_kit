RSpec.describe Indocker::Compiler::TemplateDirCompiler do
  subject{ Indocker::Compiler::TemplateDirCompiler.new }

  let(:context_helper) { test_helper.context_helper }
  let(:shell) { test_helper.shell }

  let(:source_dir) { File.join(FIXTURES_PATH, "compiler") }
  let(:destination_dir) { File.join(FIXTURES_PATH, "tmp") }

  after do 
    FileUtils.rm_r(destination_dir) if File.exists?(destination_dir)
  end

  it "re-creates compile dir" do
    expect(subject.bash_commands).to receive(:rm_rf).with(shell, destination_dir)
    expect(subject.bash_commands).to receive(:cp_r).with(shell, source_dir, destination_dir)

    allow(subject).to receive(:compile_templates)

    subject.compile(shell, source_dir, destination_dir, context_helper: context_helper)
  end

  it "compiles all files in directory" do
    expect(shell).to receive(:recursive_list_files).and_return([
      File.join(destination_dir, "erb_template.txt"),
      File.join(destination_dir, "test.txt")
    ])

    expect(subject.template_file_compiler).to receive(:compile).with(
      shell, File.join(destination_dir, "erb_template.txt"), context_helper: context_helper
    )
    expect(subject.template_file_compiler).to receive(:compile).with(
      shell, File.join(destination_dir, "test.txt"), context_helper: context_helper
    )

    subject.compile(shell, source_dir, destination_dir, context_helper: context_helper)
  end
end