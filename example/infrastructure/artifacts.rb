data_path = File.expand_path File.join(File.dirname(__FILE__), "..", "app_data")

DockerKit.add_artifact(
  DockerKit::Core::Artifacts::Local
    .new(:docker_kit_example_data)
    .setup( data_path )
)

DockerKit.add_artifact(
  DockerKit::Core::Artifacts::Git
    .new(:docker_kit_repo)
    .setup(remote_url: "git@github.com:ArtStation/docker_kit.git")
)