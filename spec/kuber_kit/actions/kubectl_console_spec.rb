RSpec.describe KuberKit::Actions::KubectlConsole do
  subject{ KuberKit::Actions::KubectlConsole.new }

  it "executes console command using kubectl" do
    expect(subject.kubectl_commands).to receive(:exec).with(subject.local_shell, 
      "auth-app", "bin/console", args: "-it", interactive: true, kubeconfig_path: nil, namespace: nil
    )
    subject.call("auth-app", {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.kubectl_commands).to receive(:exec).and_raise(KuberKit::Error.new("Some error"))
    subject.call("auth-app", {})
  end
end