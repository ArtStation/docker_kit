RSpec.describe KuberKit::ImageCompiler::BuildServerPool do
  subject{ KuberKit::ImageCompiler::BuildServerPool }

  let(:local_shell) { test_helper.shell }

  class RemoteShell < TestShell
    def connect(host:, user:, port:)
      @connected = true
    end

    def connected?
      !!@connected
    end
  end

  context "#get_shell" do
    it "returns local shell if no build server is provided" do
      pool = subject.new(local_shell: local_shell, build_servers: [], ssh_shell_class: RemoteShell)

      expect(pool.get_shell).to eq(local_shell)
    end

    it "returns remote shell if build server provided" do
      build_server = test_helper.add_build_server(:test_server)

      pool  = subject.new(local_shell: local_shell, build_servers: [build_server], ssh_shell_class: RemoteShell)
      shell = pool.get_shell

      expect(shell).to be_a(RemoteShell)
      expect(shell.connected?).to be true
    end
  end

  context "#disconnect" do
    it "disconnects all remote shells" do
      build_server = test_helper.add_build_server(:test_server)

      pool  = subject.new(local_shell: local_shell, build_servers: [build_server], ssh_shell_class: RemoteShell)
      shell = pool.get_shell

      expect(shell).to receive(:disconnect)

      pool.disconnect_all
    end
  end
end