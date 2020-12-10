RSpec.describe KuberKit::Actions::KubectlApplier do
  subject{ KuberKit::Actions::KubectlApplier.new }

  it "applies file using kubectl" do
    expect(subject.kubectl_commands).to receive(:apply_file).with(subject.local_shell, "/file/to/apply.yml", kubeconfig_path: nil, namespace: nil)
    subject.call("/file/to/apply.yml", {})
  end

  it "prints error if error happen" do
    expect(subject.ui).to receive(:print_error)
    allow(subject.kubectl_commands).to receive(:apply_file).and_raise(KuberKit::Error.new("Some error"))
    subject.call("/file/to/apply.yml", {})
  end
end