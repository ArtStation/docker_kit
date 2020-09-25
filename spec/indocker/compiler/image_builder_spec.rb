RSpec.describe Indocker::Compiler::ImageBuilder do
  subject{ Indocker::Compiler::ImageBuilder.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }

  before do
    allow(subject.docker_commands).to receive(:build)
  end

  it "builds image using docker" do
    expect(subject.docker_commands).to receive(:build).with(shell, "/tmp/build/example", ["-t=default/example:latest"])
    subject.build(shell, image, "/tmp/build/example")
  end

  it "adds tag with remote registry url" do
    registry = Indocker::Infrastructure::Registry.new(:remote).set_remote_url("http://test.com")
    Indocker::Container['infrastructure.infra_store'].add_registry(registry)

    remote_image_def = test_helper.image_definition(:remote_image).registry(:remote)
    remote_image = test_helper.image_factory.create(remote_image_def)

    expect(subject.docker_commands).to receive(:tag).with(shell, "remote/remote_image:latest", "http://test.com/remote/remote_image:latest")
    subject.build(shell, remote_image, "/tmp/build/example")
  end

  xit "pushes image to registry"
  xit "it calls before and after callbacks"
end