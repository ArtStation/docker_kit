RSpec.describe KuberKit::Tools::BuildDirCleaner do
  subject{ KuberKit::Tools::BuildDirCleaner.new }


  let(:shell) { test_helper.shell }

  it do
    expect(subject).to receive(:get_ancient_builds_dirs).and_return(["/tmp/1", "/tmp/2"])
    expect(subject.bash_commands).to receive(:rm_rf).with(shell, "/tmp/1")
    expect(subject.bash_commands).to receive(:rm_rf).with(shell, "/tmp/2")

    subject.call(shell, parent_dir: "/tmp")
  end
end