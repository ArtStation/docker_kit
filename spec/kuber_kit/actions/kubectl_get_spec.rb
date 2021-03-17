RSpec.describe KuberKit::Actions::KubectlGet do
  subject{ KuberKit::Actions::KubectlGet.new }

  it "gets pods using kubectl" do
    expect(subject.kubectl_commands).to receive(:get_resources).with(subject.local_shell, 
      "pod", kubeconfig_path: nil, namespace: nil
    ).and_return(["auth-app", "marketplace-app"])
    expect(subject.ui).to receive(:print_info).with("Pods", "auth-app")
    subject.call("auth", {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.kubectl_commands).to receive(:kubectl_run).and_raise(KuberKit::Error.new("Some error"))
    subject.call("auth-app", {})
  end
end