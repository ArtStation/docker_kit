RSpec.describe Indocker::Compiler::ImageCompiler do
  subject{ Indocker::Compiler::ImageCompiler.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }

  xit "creates a build dir"
  xit "builds docker image"
end