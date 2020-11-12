KuberKit.add_build_server(
  KuberKit::Core::BuildServers::BuildServer
    .new(:remote_bs)
    .setup(host: ENV['SSH_TEST_HOST'], user: ENV['SSH_TEST_USER'], port: 22)
)