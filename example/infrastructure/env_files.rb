DockerKit.add_env_file(
  DockerKit::Core::EnvFiles::ArtifactFile
    .new(:test, artifact_name: :docker_kit_example_data, file_path: "test.env")
)