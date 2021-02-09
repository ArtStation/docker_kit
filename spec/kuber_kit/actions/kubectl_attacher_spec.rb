RSpec.describe KuberKit::Actions::KubectlAttacher do
  subject{ KuberKit::Actions::KubectlAttacher.new }

  it "executes console command using kubectl" do
    expect(subject.kubectl_commands).to receive(:exec).with(subject.local_shell, 
      "auth-app", "bash", args: "-it", interactive: true, kubeconfig_path: nil, namespace: nil
    )
    subject.call("auth-app", {})
  end

  it "shows a deployments selection if no pod_name provided" do
    expect(subject.resources_fetcher).to receive(:call).with(
      "attach"
    ).and_return("deploy/test-app")
    expect(subject.kubectl_commands).to receive(:exec).with(subject.local_shell, 
      "deploy/test-app", "bash", args: "-it", interactive: true, kubeconfig_path: nil, namespace: nil
    )
    subject.call(nil, {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.kubectl_commands).to receive(:exec).and_raise(KuberKit::Error.new("Some error"))
    subject.call("auth-app", {})
  end
end