class KuberKit::Shell::AbstractShell
  ShellError = Class.new(KuberKit::Error)
  DirNotFoundError = Class.new(ShellError)

  def exec!(command)
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def read(file_path)
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def write(file_path, content)
    raise KuberKit::NotImplementedError, "must be implemented"
  end

  def recursive_list_files(path, name: nil)
    raise KuberKit::NotImplementedError, "must be implemented"
  end
end