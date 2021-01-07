RSpec.describe KuberKit::Actions::KubectlConsole do
  subject{ KuberKit::Actions::KubectlConsole.new }

  it "executes console command using kubectl" do
    expect(subject.kubectl_commands).to receive(:exec).with(subject.local_shell, 
      "auth-app", "bin/console", args: "-it", interactive: true, kubeconfig_path: nil, namespace: nil
    )
    subject.call("auth-app", {})
  end

  it "shows a deployments selection if no pod_name provided" do
    expect(subject.kubectl_commands).to receive(:get_resources).with(
      subject.local_shell,  "deployments", any_args
    ).and_return("test-app")
    expect(subject.ui).to receive(:prompt).with(
      "Please select deployment to attach", ["deploy/test-app"]
    ).and_return("deploy/test-app")
    expect(subject.kubectl_commands).to receive(:exec).with(subject.local_shell, 
      "deploy/test-app", "bin/console", args: "-it", interactive: true, kubeconfig_path: nil, namespace: nil
    )
    subject.call(nil, {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.kubectl_commands).to receive(:exec).and_raise(KuberKit::Error.new("Some error"))
    subject.call("auth-app", {})
  end
end