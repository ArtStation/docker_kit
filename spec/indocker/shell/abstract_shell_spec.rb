RSpec.describe Indocker::Shell::AbstractShell do
  subject { Indocker::Shell::AbstractShell.new }

  it do
    expect{ subject.exec!("command") }.to raise_error(Indocker::NotImplementedError)
  end

  it do
    expect{ subject.read("file_path") }.to raise_error(Indocker::NotImplementedError)
  end

  it do
    expect{ subject.write("file_path", "content") }.to raise_error(Indocker::NotImplementedError)
  end

  it do
    expect{ subject.recursive_list_files("dir_path") }.to raise_error(Indocker::NotImplementedError)
  end
end