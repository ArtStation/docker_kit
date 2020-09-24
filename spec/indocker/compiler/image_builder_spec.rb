RSpec.describe Indocker::Compiler::ImageBuilder do
  subject{ Indocker::Compiler::ImageBuilder.new }

  let(:image) { get_test_image(:example) }
  let(:shell) { Indocker::Shell::LocalShell.new }

  it "builds image using docker" do
    expect(subject.docker_commands).to receive(:build).with(shell, "/tmp/build/example")
    subject.build(shell, image, "/tmp/build/example")
  end
end