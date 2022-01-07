RSpec.describe KuberKit::Actions::KubectlEnv do
  subject{ KuberKit::Actions::KubectlEnv.new }

  let(:artifact) { KuberKit::Core::Artifacts::Local.new(:kubeconfig).setup(File.join(FIXTURES_PATH, "kubeconfig")) }
  let(:artifact_path) { KuberKit::Core::ArtifactPath.new(artifact_name: :kubeconfig, file_path: "kubeconfig.yml") }

  before do
    test_helper.artifact_store.add(artifact)

    test_helper
      .configuration_store
      .define(:production)
      .use_artifact(:kubeconfig, as: :kubeconfig)
      .kubeconfig_path(artifact_path)

    KuberKit.set_configuration_name(:production)
  end

  it "prints export env path for KUBECONFIG file" do
    expect(subject.ui).to receive(:print_info).with("ENV", "export KUBECONFIG=#{FIXTURES_PATH}/kubeconfig/kubeconfig.yml")
    subject.call({})
  end
end