KuberKit.add_template(
  KuberKit::Core::Templates::ArtifactFile
    .new(:service, artifact_name: :kuber_kit_example_data, file_path: "service.yml")
)

KuberKit.add_template(
  KuberKit::Core::Templates::ArtifactFile
    .new(:env_file, artifact_name: :kuber_kit_example_data, file_path: "env_file.yml")
)

KuberKit.add_template(
  KuberKit::Core::Templates::ArtifactFile
    .new(:docker_compose, artifact_name: :kuber_kit_example_data, file_path: "docker_compose.yml")
)