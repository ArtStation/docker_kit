RSpec.describe Indocker::Compiler::ImageBuildDirCreator do
  subject{ Indocker::Compiler::ImageBuildDirCreator.new }

  let(:image) { get_test_image(:example) }
  let(:shell) { Indocker::Shell::LocalShell.new }

  xit "compiles dockerfile & build context"
  xit "creates a gitignore file"
end