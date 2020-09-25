class Indocker::Shell::LocalShell
  ShellError = Class.new(StandardError)

  def exec!(command)
    result = 
    IO.popen(command, err: [:child, :out]) do |io|
      result = io.read.chomp.strip
    end

    if $?.exitstatus != 0
      raise ShellError, "Shell command failed: #{command}\r\n#{result}"
    end

    result
  end

  def read(file_path)
    File.read(file_path)
  end

  def write(file_path, content)
    File.write(file_path, content)
  end

  def recursive_list_files(path, name: nil)
    command = %Q{find -L #{path}  -type f}
    command += " -name #{name}" if name
    exec!(command).split(/[\r\n]+/)
  end
end