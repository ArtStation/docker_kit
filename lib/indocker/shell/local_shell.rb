class Indocker::Shell::LocalShell < Indocker::Shell::AbstractShell
  include Indocker::Import[
    "tools.logger",
    "shell.command_counter"
  ]

  def exec!(command)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    logger.info("Executed command [#{command_number}]: #{command.to_s.cyan}")

    result = nil
    IO.popen(command, err: [:child, :out]) do |io|
      result = io.read.chomp.strip
    end

    if result && result != ""
      logger.info("Finished command [#{command_number}] with result: \n#{result.grey}")
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
    dir_path = File.dirname(file_path)
    unless Dir.exists?(dir_path)
      FileUtils.mkdir_p(dir_path)
    end
    File.write(file_path, content)
  end

  def recursive_list_files(path, name: nil)
    command = %Q{find -L #{path}  -type f}
    command += " -name #{name}" if name
    exec!(command).split(/[\r\n]+/)
  rescue => e
    if e.message.include?("No such file or directory")
      raise DirNotFoundError.new("Dir not found: #{path}")
    else
      raise e
    end
  end
end