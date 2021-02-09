RSpec.describe KuberKit::Kubernetes::ResourcesFetcher do
  subject{ KuberKit::Kubernetes::ResourcesFetcher.new }

  it "shows a deployments selection" do
    expect(subject.kubectl_commands).to receive(:get_resources).with(
      subject.local_shell,  "deployments", any_args
    ).and_return("test-app")
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to attach", ["deploy/test-app"]
    ).and_return("deploy/test-app")
    subject.call("attach")
  end
end