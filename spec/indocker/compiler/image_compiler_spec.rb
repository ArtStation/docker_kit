RSpec.describe Indocker::Compiler::ImageCompiler do
  subject{ Indocker::Compiler::ImageCompiler.new }

  let(:image) { get_test_image(:example) }
  let(:shell) { Indocker::Shell::LocalShell.new }

  xit "compiles image build context & dockerfile" do
    subject.compile(shell, image, "/tmp/images/")

    expect(subject.template_dir_compiler).to receive(:compile)
    expect(subject.template_file_compiler).to receive(:compile)
  end
end