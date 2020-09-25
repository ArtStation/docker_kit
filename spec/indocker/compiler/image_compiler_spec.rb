RSpec.describe Indocker::Compiler::ImageCompiler do
  subject{ Indocker::Compiler::ImageCompiler.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }

  before do
    allow(subject.image_build_dir_creator).to receive(:create)
    allow(subject.image_builder).to receive(:build)
  end

  it "creates a build dir" do
    expect(subject.image_build_dir_creator).to receive(:create).with(shell, image, "/tmp/images/example")

    subject.compile(shell, image, "/tmp/images")
  end

  it "builds docker image" do
    expect(subject.image_builder).to receive(:build).with(shell, image, "/tmp/images/example", args: [])

    subject.compile(shell, image, "/tmp/images")
  end
end