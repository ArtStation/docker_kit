RSpec.describe Indocker::Compiler::ImageCompiler do
  subject{ Indocker::Compiler::ImageCompiler.new }

  let(:image) { get_test_image(:example) }
  let(:shell) { Indocker::Shell::LocalShell.new }

  xit "creates a build dir"
  xit "builds docker image"
end