RSpec.describe KuberKit::Kubernetes::ResourcesFetcher do
  subject{ KuberKit::Kubernetes::ResourcesFetcher.new }

  it "returns list of resources with given type in k8s" do
    expect(subject.kubectl_commands).to receive(:get_resources).with(
      subject.local_shell, 
      "deployments",
      jsonpath:         ".items[*].metadata.name", 
      kubeconfig_path:  nil,
      namespace:        nil
    ).and_return(["test-app"])

    result = subject.call("deployments")
  end
end