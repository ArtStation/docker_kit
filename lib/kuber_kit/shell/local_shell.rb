require 'fileutils'

class KuberKit::Shell::LocalShell < KuberKit::Shell::AbstractShell
  MAX_LINES_TO_PRINT = 50

  include KuberKit::Import[
    "shell.command_counter",
    "shell.rsync_commands",
    "ui",
  ]

  def exec!(command, log_command: true)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    if log_command
      ui.print_debug("LocalShell", "Execute: [#{command_number}]: #{command.to_s.cyan}")
    end

    result = nil
    IO.popen(wrap_command_with_pid(command), err: [:child, :out]) do |io|
      result = io.read.chomp.strip
    end

    if result && result != "" && log_command
      print_result = result
      print_result_lines = print_result.split("\n")

      if print_result_lines.count >= MAX_LINES_TO_PRINT
        print_result = [
          "[Result is too long, showing only first and last items]".yellow, 
          print_result_lines.first, 
          "[#{print_result_lines.count - 2} lines not showing]".yellow, 
          print_result_lines.last
      ].join("\n")
      end

      ui.print_debug("LocalShell", "Finished [#{command_number}] with result: \n  ----\n#{print_result.grey}\n  ----")
    end

    if $?.exitstatus != 0
      raise ShellError, "Shell command failed: #{command}\r\n#{result}"
    end

    result
  end

  def interactive!(command, log_command: true)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    if log_command
      ui.print_debug("LocalShell", "Interactive: [#{command_number}]: #{command.to_s.cyan}")
    end

    result = system(wrap_command_with_pid(command))

    if !$?.success?
      raise ShellError, "Shell command failed: #{command}\r\n#{result}"
    end
  end

  def replace!(shell_name: nil, env: [], log_command: true)
    shell_name ||= "$SHELL"
    command = (env + [shell_name]).join(" ")

    if log_command
      ui.print_debug("LocalShell", "Replace Shell: #{command.to_s.cyan}")
    end

    system_exec(command)
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

    ui.print_debug("LocalShell", "Created file #{file_path.to_s.cyan}\r\n  ----\r\n#{content.grey}\r\n  ----")

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
    command += " -name '#{name}'" if name
    exec!(command).split(/[\r\n]+/)
  rescue => e
    if e.message.include?("No such file or directory")
      raise DirNotFoundError.new("Dir not found: #{path}")
    else
      raise e
    end
  end

  def list_dirs(path)
    command = %Q{find -L #{path} -maxdepth 0 -type d}
    exec!(command).split(/[\r\n]+/)
  rescue => e
    if e.message.include?("No such file or directory")
      raise DirNotFoundError.new("Dir not found: #{path}")
    else
      raise e
    end
  end

  def wrap_command_with_pid(command)
    "KIT=#{Process.pid} #{command}"
  end

  private
    def system_exec(command)
      exec(command)
    end

    def ensure_directory_exists(file_path)
      dir_path = File.dirname(file_path)

      unless Dir.exists?(dir_path)
        FileUtils.mkdir_p(dir_path)
      end
    end
end