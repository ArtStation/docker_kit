require 'tempfile'

class KuberKit::Shell::SshShell < KuberKit::Shell::LocalShell
  include KuberKit::Import[
    "tools.logger",
    "shell.command_counter",
    "shell.rsync_commands",
    "shell.local_shell"
  ]

  def connect(host:, user:, port:)
    @ssh_session = KuberKit::Shell::SshSession.new(host: host, user: user, port: port)
  end
  
  def connected?
    @ssh_session && @ssh_session.connected?
  end

  def disconnect
    @ssh_session.disconnect if @ssh_session
  end

  def exec!(command, log_command: true)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    if log_command
      logger.info("#{ssh_session.host.green} > Execute: [#{command_number}]: #{command.to_s.cyan}")
    end

    result = ssh_session.exec!(command)

    if result && result != "" && log_command
      logger.info("#{ssh_session.host.green} > Finished [#{command_number}] with result: \n#{result.grey}")
    end

    result
  rescue KuberKit::Shell::SshSession::SshSessionError => e
    raise ShellError.new(e.message)
  end

  def sync(local_path, remote_path, exclude: nil)
    rsync_commands.rsync(
      local_shell, local_path, remote_path, 
      target_host: "#{ssh_session.user}@#{ssh_session.host}",
      exclude:     exclude
    )
  end

  def read(file_path)
    exec!("cat #{file_path}")
  end

  def write(file_path, content)
    Tempfile.create do |file| 
      file << content
      file.flush
      sync(file.path, file_path)
    end

    logger.info("Created file #{file_path.to_s.cyan}\r\n#{content.grey}")

    true
  end

  private
    def ssh_session
      unless connected?
        raise ArgumentError, "ssh session is not created, please call #connect"
      end

      @ssh_session
    end

    def ensure_directory_exists(file_path)
      exec!("mkdir -p #{file_path}")
    end
end