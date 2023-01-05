require 'tempfile'

class KuberKit::Shell::SshShell < KuberKit::Shell::LocalShell
  include KuberKit::Import[
    "ui",
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

  def exec!(command, log_command: true, merge_stderr: false)
    command_number = command_counter.get_number.to_s.rjust(2, "0")
    
    if log_command
      ui.print_debug("SshShell", "#{ssh_session.host.green} > Execute: [#{command_number}]: #{command.to_s.cyan}")
    end

    result = ssh_session.exec!(wrap_command_with_pid(command), merge_stderr: merge_stderr)

    if result && result != "" && log_command
      ui.print_debug("SshShell", "#{ssh_session.host.green} > Finished [#{command_number}] with result: \n#{result.grey}")
    end

    result
  rescue KuberKit::Shell::SshSession::SshSessionError => e
    raise ShellError.new(e.message)
  end

  def interactive!(command, log_command: true)
    raise "Currently interactive run is not supported for ssh shell."
  end

  def replace!(shell_name: nil, env: [])
    raise "Currently repliace run is not supported for ssh shell."
  end

  def sync(local_path, remote_path, exclude: nil, delete: true)
    rsync_commands.rsync(
      local_shell, local_path, remote_path, 
      target_host: "#{ssh_session.user}@#{ssh_session.host}",
      exclude:     exclude,
      delete:      delete
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

    ui.print_debug("SshShell", "Created file #{file_path.to_s.cyan}\r\n  ----\r\n#{content.grey}\r\n  ----")

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