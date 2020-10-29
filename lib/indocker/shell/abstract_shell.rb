class Indocker::Shell::AbstractShell
  ShellError = Class.new(Indocker::Error)
  DirNotFoundError = Class.new(ShellError)

  def exec!(command)
    raise Indocker::NotImplementedError, "must be implemented"
  end

  def read(file_path)
    raise Indocker::NotImplementedError, "must be implemented"
  end

  def write(file_path, content)
    raise Indocker::NotImplementedError, "must be implemented"
  end

  def recursive_list_files(path, name: nil)
    raise Indocker::NotImplementedError, "must be implemented"
  end
end