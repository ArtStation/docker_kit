class KuberKit::ImageCompiler::BuildServerPool
  attr_reader :ssh_shells, :local_shell
  
  def initialize(local_shell:, build_servers:, ssh_shell_class:)
    @local_shell     = local_shell
    @ssh_shell_class = ssh_shell_class
    @build_servers   = build_servers
    @ssh_shells      = []
  end

  def get_shell
    if @build_servers.any?
      shell = connect_to_ssh_shell(@build_servers.sample)
      @ssh_shells << shell
      shell
    else
      @local_shell
    end
  end

  def disconnect_all
    @ssh_shells.each(&:disconnect)
  end

  private
    def connect_to_ssh_shell(bs)
      shell = @ssh_shell_class.new
      shell.connect(host: bs.host, user: bs.user, port: bs.port)
      shell
    end
end