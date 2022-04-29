RSpec.describe KuberKit::ShellLauncher::Strategies::Kubernetes do
  subject{ KuberKit::ShellLauncher::Strategies::Kubernetes.new() }

  let(:shell) { test_helper.shell }

  before do
    test_helper
      .configuration_store
      .define(:production)
      .kubeconfig_path("/path/to/kubeconfig")
      .deployer_namespace("prod")
    
    KuberKit.set_configuration_name(:production)
  end

  it "launches a shell with required env variables" do
    expect(subject.kubectl_commands).to receive(:set_namespace).with(shell, "prod", kubeconfig_path: "/path/to/kubeconfig")
    expect(shell).to receive(:replace!).with(env: ["KUBECONFIG=/path/to/kubeconfig"])
    
    subject.call(shell)
  end
end