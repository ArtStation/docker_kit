require 'net/ssh'

class KuberKit::Shell::SshSession
  SshSessionError = Class.new(KuberKit::Error)

  attr_reader :session, :host, :user, :port

  def initialize(host:, user:, port:)
    @host = host
    @user = user
    @port = port
    @session = Net::SSH.start(host, user, {port: port})
  end

  def connected?
    !!@session
  end
  
  def disconnect
    return unless connected?
    @session.close
    @session = nil
  end

  def exec!(command)
    stdout_data = ''
    stderr_data = ''
    exit_code = nil
    channel = session.open_channel do |ch|
      ch.exec(command) do |ch, success|
        if !success
          raise SshSessionError, "Shell command failed: #{command}\r\n#{stdout_data}\r\n#{stderr_data}"
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
    session.loop

    stdout_data = stdout_data.chomp.strip

    if exit_code != 0
      raise SshSessionError, "Shell command failed: #{command}\r\n#{stdout_data}\r\n#{stderr_data}"
    end

    stdout_data
  end
end