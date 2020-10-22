Indocker.add_env_file(
  Indocker::Core::EnvFiles::ArtifactFile
    .new(:test, artifact_name: :indocker_example_data, file_path: "test.env")
)