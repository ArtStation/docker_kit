RSpec.describe Indocker::Compiler::ImageBuildDirCreator do
  subject{ Indocker::Compiler::ImageBuildDirCreator.new }

  let(:image) { test_helper.image(:example) }
  let(:shell) { test_helper.shell }

  before do
    allow(subject.template_dir_compiler).to receive(:compile)
    allow(subject.template_file_compiler).to receive(:compile)
  end

  it "creates a build dir" do
    expect(subject.bash_commands).to receive(:rm_rf).with(shell, "/tmp/images/example")
    expect(subject.bash_commands).to receive(:mkdir_p).with(shell, "/tmp/images/example")

    subject.create(shell, image, "/tmp/images/example")
  end

  it "compiles dockerfile & build context" do
    expect(subject.template_dir_compiler).to receive(:compile).with(
      shell, "/images/example/build_context", "/tmp/images/example", context_helper: nil
    )
    expect(subject.template_file_compiler).to receive(:compile).with(
      shell, "/images/example/Dockerfile", destination_path: "/tmp/images/example/Dockerfile", context_helper: nil
    )

    subject.create(shell, image, "/tmp/images/example")
  end

  it "creates a docker ignore file" do
    Indocker::Container["configs"].docker_ignore_list = ["log", "tmp"]

    expect(shell).to receive(:write).with(
      "/tmp/images/example/.dockerignore", /Dockerfile/
    )

    subject.create(shell, image, "/tmp/images/example")
  end
end