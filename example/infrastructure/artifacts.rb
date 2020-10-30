data_path = File.expand_path File.join(File.dirname(__FILE__), "..", "app_data")

KuberKit.add_artifact(
  KuberKit::Core::Artifacts::Local
    .new(:kuber_kit_example_data)
    .setup( data_path )
)

KuberKit.add_artifact(
  KuberKit::Core::Artifacts::Git
    .new(:kuber_kit_repo)
    .setup(remote_url: "git@github.com:ArtStation/kuber_kit.git")
)