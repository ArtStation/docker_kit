RSpec.describe KuberKit::Kubernetes::ResourceSelector do
  subject{ KuberKit::Kubernetes::ResourceSelector.new }

  it "shows a deployments selection" do
    expect(subject.resources_fetcher).to receive(:call).with(
      "deployments"
    ).and_return(["test-app"])
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to attach", ["deploy/test-app"]
    ).and_return("deploy/test-app")

    result = subject.call("attach")

    expect(result).to eq("deploy/test-app")
  end

  it "shows pods selection if option provided" do
    expect(subject.resources_fetcher).to receive(:call).with(
      "deployments"
    ).and_return(["test-app"])
    expect(subject.resources_fetcher).to receive(:call).with(
      "pods"
    ).and_return(["test-app"])
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to attach", ["deploy/test-app", "pods"]
    ).and_return("pods")
    expect(subject.ui).to receive(:prompt).with(
      "Please select pod to attach", ["pods/test-app"]
    ).and_return("pods/test-app")

    result = subject.call("attach", include_pods: true)

    expect(result).to eq("pods/test-app")
  end

  it "shows ingresses selection if option provided" do
    expect(subject.resources_fetcher).to receive(:call).with(
      "deployments"
    ).and_return(["test-app"])
    expect(subject.resources_fetcher).to receive(:call).with(
      "ingresses"
    ).and_return(["test-app"])
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to attach", ["deploy/test-app", "ingresses"]
    ).and_return("ingresses")
    expect(subject.ui).to receive(:prompt).with(
      "Please select ingress to attach", ["ingresses/test-app"]
    ).and_return("ingresses/test-app")

    result = subject.call("attach", include_ingresses: true)

    expect(result).to eq("ingresses/test-app")
  end
end