RSpec.describe KuberKit::Tools::FilesSync do
  subject{ KuberKit::Tools::FilesSync.new }

  it do
    expect(subject.rsync_commands).to receive(:rsync).with(subject.local_shell, "/path/from", "/path/to", exclude: "exclude-path")
    subject.sync("/path/from", "/path/to", exclude: "exclude-path")
  end
end