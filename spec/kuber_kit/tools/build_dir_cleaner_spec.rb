RSpec.describe KuberKit::Tools::BuildDirCleaner do
  subject{ KuberKit::Tools::BuildDirCleaner.new }

  it do
    expect(subject).to receive(:get_ancient_builds_dirs).and_return(["/tmp/1", "/tmp/2"])
    expect(subject.bash_commands).to receive(:rm_rf).with(subject.local_shell, "/tmp/1")
    expect(subject.bash_commands).to receive(:rm_rf).with(subject.local_shell, "/tmp/2")

    subject.call(parent_dir: "/tmp")
  end
end