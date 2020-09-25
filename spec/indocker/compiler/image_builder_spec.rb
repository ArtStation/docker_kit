RSpec.describe Indocker::Compiler::ImageBuilder do
  subject{ Indocker::Compiler::ImageBuilder.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }

  it "builds image using docker" do
    expect(subject.docker_commands).to receive(:build).with(shell, "/tmp/build/example", ["-t=default/example:latest"])
    subject.build(shell, image, "/tmp/build/example")
  end

  it "adds tag with remote registry url" do
    remote_image = test_helper.remote_image(:remote_image, "http://test.com")

    expect(subject.docker_commands).to receive(:tag).with(shell, "remote/remote_image:latest", "http://test.com/remote/remote_image:latest")
    subject.build(shell, remote_image, "/tmp/build/remote_image")
  end

  it "pushes image to registry" do
    remote_image = test_helper.remote_image(:remote_image, "http://test.com")

    expect(subject.docker_commands).to receive(:push).with(shell, "http://test.com/remote/remote_image:latest")
    subject.build(shell, remote_image, "/tmp/build/remote_image")
  end

  it "calls before and after callbacks" do
    before_counter = 0
    after_counter = 0

    image_def = test_helper.image_definition(:image)
      .before_build{ before_counter += 1 }
      .after_build{ after_counter += 1 }
    image = test_helper.image_factory.create(image_def)

    subject.build(shell, image, "/tmp/build/example")

    expect(before_counter).to eq(1)
    expect(after_counter).to eq(1)
  end
end