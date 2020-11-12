require 'fileutils'
require 'net/ssh'

class KuberKit::Shell::SshShell < KuberKit::Shell::LocalShell
  include KuberKit::Import[
    "tools.logger",
    "shell.command_counter"
  ]

  def connect(host:, user:, port:)
    @ssh_session = Net::SSH.start(host, user, {port: port})
  end

  def connected?
    !!@ssh_session
  end

  def ssh_session
    raise ArgumentError, "ssh session is not created, please call #connect" unless connected?

    @ssh_session
  end
  
  def disconnect
    @ssh_session.close
    @ssh_session = nil
  end

  def exec!(command, log_command: true)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    if log_command
      logger.info("Executed command [#{command_number}]: #{command.to_s.cyan}")
    end

    stdout_data = ''
    stderr_data = ''
    exit_code = nil
    channel = ssh_session.open_channel do |ch|
      ch.exec(command) do |ch, success|
        if !success
          raise ShellError, "Shell command failed: #{command}\r\n#{stdout_data}\r\n#{stderr_data}"
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
    content = content.gsub("'", "\'").gsub('"', '\"')
    exec!("echo \"#{content}\" > #{file_path}", log_command: false)

    logger.info("Created file #{file_path.to_s.cyan}\r\n#{content.grey}")

    true
  end

  private
    def ensure_directory_exists(file_path)
      exec!("mkdir -p #{file_path}")
    end
end