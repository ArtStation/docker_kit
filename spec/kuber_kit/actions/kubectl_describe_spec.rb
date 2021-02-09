RSpec.describe KuberKit::Actions::KubectlDescribe do
  subject{ KuberKit::Actions::KubectlDescribe.new }

  it "describes deployment using kubectl" do
    expect(subject.kubectl_commands).to receive(:describe).with(subject.local_shell, 
      "deploy/auth-app", args: nil, kubeconfig_path: nil, namespace: nil
    )
    subject.call("deploy/auth-app", {})
  end

  it "shows a deployments selection if no resource_name provided" do
    expect(subject.kubectl_commands).to receive(:get_resources).with(
      subject.local_shell,  "deployments", any_args
    ).and_return("test-app")
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to describe",  ["deploy/test-app", "ingresses", "pods"]
    ).and_return("deploy/test-app")
    expect(subject.kubectl_commands).to receive(:describe).with(subject.local_shell, 
      "deploy/test-app", args: nil, kubeconfig_path: nil, namespace: nil
    )
    subject.call(nil, {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.kubectl_commands).to receive(:exec).and_raise(KuberKit::Error.new("Some error"))
    subject.call("auth-app", {})
  end
end