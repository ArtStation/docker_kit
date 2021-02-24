RSpec.describe KuberKit::Kubernetes::ResourceSelector do
  subject{ KuberKit::Kubernetes::ResourceSelector.new }

  it "shows a deployments selection" do
    expect(subject.resources_fetcher).to receive(:call).with(
      "deployments"
    ).and_return(["test-app"])
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to attach", ["deploy/test-app"]
    ).and_return("deploy/test-app")
    subject.call("attach")
  end
end