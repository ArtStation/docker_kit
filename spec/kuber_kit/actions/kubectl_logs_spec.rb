RSpec.describe KuberKit::Actions::KubectlLogs do
  subject{ KuberKit::Actions::KubectlLogs.new }

  it "shows logs using kubectl" do
    expect(subject.kubectl_commands).to receive(:logs).with(subject.local_shell, 
      "auth-app", args: nil, kubeconfig_path: nil, namespace: nil
    )
    subject.call("auth-app", {})
  end

  it "shows a deployments selection if no pod_name provided" do
    expect(subject.resource_selector).to receive(:call).with(
      "attach", additional_resources: ["pod", "job"]
    ).and_return("deploy/test-app")
    expect(subject.kubectl_commands).to receive(:logs).with(subject.local_shell, 
      "deploy/test-app", args: nil, kubeconfig_path: nil, namespace: nil
    )
    subject.call(nil, {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.kubectl_commands).to receive(:kubectl_run).and_raise(KuberKit::Error.new("Some error"))
    subject.call("deploy/auth-app", {})
  end
end