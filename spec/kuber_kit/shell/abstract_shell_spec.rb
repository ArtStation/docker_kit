RSpec.describe KuberKit::Shell::AbstractShell do
  subject { KuberKit::Shell::AbstractShell.new }

  it do
    expect{ subject.exec!("command") }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.interactive!("command") }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.read("file_path") }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.write("file_path", "content") }.to raise_error(KuberKit::NotImplementedError)
  end


  it do
    expect{ subject.sync("local_path", "remote_path") }.to raise_error(KuberKit::NotImplementedError)
  end

  it do
    expect{ subject.recursive_list_files("dir_path") }.to raise_error(KuberKit::NotImplementedError)
  end
end