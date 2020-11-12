require 'fileutils'

class KuberKit::Shell::LocalShell < KuberKit::Shell::AbstractShell
  include KuberKit::Import[
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
    ensure_directory_exists(file_path)

    File.write(file_path, content)

    logger.info("Created file #{file_path.to_s.cyan}\r\n#{content.grey}")

    true
  end

  def delete(file_path)
    FileUtils.rm(file_path)
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

  private
    def ensure_directory_exists(file_path)
      dir_path = File.dirname(file_path)

      unless Dir.exists?(dir_path)
        FileUtils.mkdir_p(dir_path)
      end
    end
end