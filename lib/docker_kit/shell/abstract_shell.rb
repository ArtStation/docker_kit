class DockerKit::Shell::AbstractShell
  ShellError = Class.new(DockerKit::Error)
  DirNotFoundError = Class.new(ShellError)

  def exec!(command)
    raise DockerKit::NotImplementedError, "must be implemented"
  end

  def read(file_path)
    raise DockerKit::NotImplementedError, "must be implemented"
  end

  def write(file_path, content)
    raise DockerKit::NotImplementedError, "must be implemented"
  end

  def recursive_list_files(path, name: nil)
    raise DockerKit::NotImplementedError, "must be implemented"
  end
end