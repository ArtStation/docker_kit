RSpec.describe Indocker::Shell::LocalShell do
  subject{ Indocker::Shell::LocalShell.new }

  it "executes given command locally and returns result" do
    path = File.expand_path(__dir__)
    result = subject.exec!("ls #{path} | grep local_shell_spec")
    expect(result).to eq("local_shell_spec.rb")
  end
end