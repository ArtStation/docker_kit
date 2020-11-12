require 'fileutils'
require 'net/ssh'

class KuberKit::Shell::SshShell < KuberKit::Shell::AbstractShell
  include KuberKit::Import[
    "tools.logger",
    "shell.command_counter"
  ]

  def connect(host:, user:, port:)
    @ssh_session = Net::SSH.start(host, user, {port: port})
  end

  def ssh_session
    raise ArgumentError, "ssh session is not created, please call #connect" if @ssh_session.nil?

    @ssh_session
  end

  def exec!(command)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    logger.info("Executed command [#{command_number}]: #{command.to_s.cyan}")

    stdout_data = ''
    stderr_data = ''
    exit_code = nil
    channel = ssh_session.open_channel do |ch|
      ch.exec(command) do |ch, success|
        if !success
          raise ShellError, "Shell command failed: #{command}\r\n#{stdout_data}\r\n#{stderr_data}"
          abort('failed')
        end

        channel.on_data do |ch,data|
          stdout_data += data
        end

        channel.on_extended_data do |ch,type,data|
          stderr_data += data
        end

        channel.on_request('exit-status') do |ch,data|
          exit_code = data.read_long
        end
      end
    end

    channel.wait
    ssh_session.loop

    stdout_data = stdout_data.chomp.strip

    if exit_code != 0
      raise ShellError, "Shell command failed: #{command}\r\n#{stdout_data}\r\n#{stderr_data}"
    end

    if stdout_data && stdout_data != ""
      logger.info("Finished command [#{command_number}] with result: \n#{stdout_data.grey}")
    end

    stdout_data
  end

  def read(file_path)
    exec!("cat #{file_path}")
  end

  def write(file_path, content)
    exec!("echo #{content} > #{file_path}")
  end

  def delete(file_path)
    exec!("rm #{file_path}")
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