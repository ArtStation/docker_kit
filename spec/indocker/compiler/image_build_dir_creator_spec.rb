RSpec.describe Indocker::Compiler::ImageBuildDirCreator do
  subject{ Indocker::Compiler::ImageBuildDirCreator.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }

  it "creates a build dir" do
    expect(subject.bash_commands).to receive(:rm_rf).with(shell, "/tmp/images/example")
    expect(subject.bash_commands).to receive(:mkdir_p).with(shell, "/tmp/images/example")

    subject.create(shell, image, "/tmp/images/example")
  end

  xit "compiles dockerfile & build context" do
    expect(subject.template_dir_compiler).to receive(:compile)
    expect(subject.template_file_compiler).to receive(:compile)

    subject.create(shell, image, "/tmp/images/example")
  end

  xit "creates a gitignore file"
end