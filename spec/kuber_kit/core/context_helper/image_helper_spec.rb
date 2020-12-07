RSpec.describe KuberKit::Core::ContextHelper::ImageHelper do
  let(:image) { test_helper.image(:auth_app) }

  subject{ KuberKit::Core::ContextHelper::ImageHelper.new(
    image_store:      test_helper.image_store,
    artifact_store:   KuberKit::Container['core.artifact_store'],
    shell:            test_helper.shell,
    env_file_reader:  KuberKit::Container['env_file_reader.action_handler'],
    image:            image
  ) }

  context "image_name" do
    it "returns image name of current image" do
      expect(subject.image_name).to eq("auth_app")
    end
  end

  context "build_vars" do
    let(:image) { test_helper.image(:auth_app, build_vars: {admin_name: "test"}) }

    it "returns build_vars for current image" do
      expect(subject.build_vars.admin_name).to eq("test")
    end
  end
end