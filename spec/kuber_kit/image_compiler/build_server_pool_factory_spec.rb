RSpec.describe KuberKit::ImageCompiler::BuildServerPoolFactory do
  subject{ KuberKit::ImageCompiler::BuildServerPoolFactory.new }

  class RemoteSshShell < TestShell
    def connect(host:, user:, port:)
      @connected = true
    end
  end

  it "returns build server pool based on configuration" do
    build_server = test_helper.add_build_server(:test_server)
    test_helper.configuration_store.define(:production).use_build_server(:test_server)
    KuberKit.set_configuration_name(:production)

    pool = subject.create(ssh_shell_class: RemoteSshShell)

    expect(pool.ssh_shells.first).to be_a(RemoteSshShell)
  end
end