require 'fileutils'

class KuberKit::Shell::LocalShell < KuberKit::Shell::AbstractShell
  include KuberKit::Import[
    "tools.logger",
    "shell.command_counter",
    "shell.rsync_commands",
  ]

  def exec!(command, log_command: true)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    if log_command
      logger.info("Execute: [#{command_number}]: #{command.to_s.cyan}")
    end

    result = nil
    IO.popen(command, err: [:child, :out]) do |io|
      result = io.read.chomp.strip
    end

    if result && result != "" && log_command
      logger.info("Finished [#{command_number}] with result: \n#{result.grey}")
    end

    if $?.exitstatus != 0
      raise ShellError, "Shell command failed: #{command}\r\n#{result}"
    end

    result
  end

  def interactive!(command, log_command: true)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    if log_command
      logger.info("Interactive: [#{command_number}]: #{command.to_s.cyan}")
    end

    system(command)
  end

  def sync(local_path, remote_path, exclude: nil, delete: true)
    rsync_commands.rsync(self, local_path, remote_path, exclude: exclude, delete: delete)
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
    exec!("rm #{file_path}")
  end

  def file_exists?(file_path)
    exec!("test -f #{file_path} && echo 'true' || echo 'false'", log_command: false) == 'true'
  end

  def dir_exists?(dir_path)
    exec!("test -d #{dir_path} && echo 'true' || echo 'false'", log_command: false) == 'true'
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