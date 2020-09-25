RSpec.describe Indocker::Compiler::ImageBuilder do
  subject{ Indocker::Compiler::ImageBuilder.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }

  it "builds image using docker" do
    expect(subject.docker_commands).to receive(:build).with(shell, "/tmp/build/example")
    subject.build(shell, image, "/tmp/build/example")
  end

  xit "adds tag with local registry url"
  xit "adds tag with remote registry url"
  xit "pushes image to registry"
end