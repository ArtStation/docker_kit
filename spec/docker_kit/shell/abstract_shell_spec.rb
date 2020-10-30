RSpec.describe DockerKit::Shell::AbstractShell do
  subject { DockerKit::Shell::AbstractShell.new }

  it do
    expect{ subject.exec!("command") }.to raise_error(DockerKit::NotImplementedError)
  end

  it do
    expect{ subject.read("file_path") }.to raise_error(DockerKit::NotImplementedError)
  end

  it do
    expect{ subject.write("file_path", "content") }.to raise_error(DockerKit::NotImplementedError)
  end

  it do
    expect{ subject.recursive_list_files("dir_path") }.to raise_error(DockerKit::NotImplementedError)
  end
end