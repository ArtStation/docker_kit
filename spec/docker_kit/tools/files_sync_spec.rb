RSpec.describe DockerKit::Tools::FilesSync do
  subject{ DockerKit::Tools::FilesSync.new }

  it do
    expect(subject.rsync_commands).to receive(:rsync).with(subject.local_shell, "/path/from", "/path/to", exclude: "exclude-path")
    subject.sync("/path/from", "/path/to", exclude: "exclude-path")
  end
end