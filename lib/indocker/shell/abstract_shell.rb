class Indocker::Shell::AbstractShell
  ShellError = Class.new(StandardError)

  def exec!(command)
    raise "must be implemented"
  end

  def read(file_path)
    raise "must be implemented"
  end

  def write(file_path, content)
    raise "must be implemented"
  end

  def recursive_list_files(path, name: nil)
    raise "must be implemented"
  end
end