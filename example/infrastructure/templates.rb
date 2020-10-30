DockerKit.add_template(
  DockerKit::Core::Templates::ArtifactFile
    .new(:service, artifact_name: :docker_kit_example_data, file_path: "service.yml")
)