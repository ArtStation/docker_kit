Indocker.add_template(
  Indocker::Core::Templates::ArtifactFile
    .new(:service, artifact_name: :indocker_example_data, file_path: "service.yml")
)