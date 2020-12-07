RSpec.describe KuberKit::Core::ContextHelper::BaseHelper do
  subject{ KuberKit::Core::ContextHelper::BaseHelper.new(
    image_store:      test_helper.image_store,
    artifact_store:   KuberKit::Container['core.artifact_store'],
    env_file_reader:  KuberKit::Container['env_file_reader.action_handler'],
    shell:            test_helper.shell
  ) }

  context "image_url" do
    it "returns image_url" do
      test_helper.image_store.define(:example)

      expect(subject.image_url(:example)).to eq("default/example:latest")
    end

    it "returns full image_url for remote registry" do
      test_helper.add_registry(:remote, "http://example.com")
      test_helper.image_store.define(:example).registry(:remote)

      expect(subject.image_url(:example)).to eq("http://example.com/remote/example:latest")
    end
  end

  context "artifact_path" do
    it "returns artifacts cloned path" do
      test_helper.add_artifact(:example_repo, "git@github.com/myapp.git")

      expect(subject.artifact_path(:example_repo)).to eq("/tmp/kuber_kit/artifacts/example_repo")
    end

    it "returns artifacts path to specific file if needed" do
      test_helper.add_artifact(:example_repo, "git@github.com/myapp.git")

      expect(subject.artifact_path(:example_repo, "test.txt")).to eq("/tmp/kuber_kit/artifacts/example_repo/test.txt")
    end
  end

  context "configuration_name" do
    it "returns configuration name" do
      expect(subject.configuration_name).to eq(:default)
    end
  end

  context "env_file" do
    let(:artifact) { KuberKit::Core::Artifacts::Local.new(:env_files).setup(File.join(FIXTURES_PATH, "env_files")) }
    let(:env_file) { KuberKit::Core::EnvFiles::ArtifactFile.new(:test_env, artifact_name: :env_files, file_path: "test.env") }

    before do
      test_helper.env_file_store.add(env_file)
      test_helper.artifact_store.add(artifact)
    end

    it "returns content of env file" do
      expect(subject.env_file(:test_env)["RUBY_ENV"]).to eq("review")
    end
  end

  context "global_build_vars" do
    it "returns attribute rewritten in configuration" do
      test_helper.configuration_store.get_definition(:default).global_build_vars({some: {foo: "bar"}})

      expect(subject.global_build_vars.some.foo).to eq("bar")
    end
  end
end