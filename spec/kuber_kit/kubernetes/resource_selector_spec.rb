RSpec.describe KuberKit::Kubernetes::ResourceSelector do
  subject{ KuberKit::Kubernetes::ResourceSelector.new }

  it "shows a deploy selection" do
    expect(subject.resources_fetcher).to receive(:call).with(
      "deploy"
    ).and_return(["test-app"])
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to attach", ["deploy/test-app"]
    ).and_return("deploy/test-app")

    result = subject.call("attach")

    expect(result).to eq("deploy/test-app")
  end

  it "shows pod selection if option provided" do
    expect(subject.resources_fetcher).to receive(:call).with(
      "deploy"
    ).and_return(["test-app"])
    expect(subject.resources_fetcher).to receive(:call).with(
      "pod"
    ).and_return(["test-app"])
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to attach", ["deploy/test-app", "pod"]
    ).and_return("pod")
    expect(subject.ui).to receive(:prompt).with(
      "Please select pod to attach", ["pod/test-app"]
    ).and_return("pod/test-app")

    result = subject.call("attach", additional_resources: ["pod"])

    expect(result).to eq("pod/test-app")
  end

  it "shows ingress selection if option provided" do
    expect(subject.resources_fetcher).to receive(:call).with(
      "deploy"
    ).and_return(["test-app"])
    expect(subject.resources_fetcher).to receive(:call).with(
      "ingress"
    ).and_return(["test-app"])
    expect(subject.ui).to receive(:prompt).with(
      "Please select resource to attach", ["deploy/test-app", "ingress"]
    ).and_return("ingress")
    expect(subject.ui).to receive(:prompt).with(
      "Please select ingress to attach", ["ingress/test-app"]
    ).and_return("ingress/test-app")

    result = subject.call("attach", additional_resources: ["ingress"])

    expect(result).to eq("ingress/test-app")
  end
end