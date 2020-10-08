data_path = File.expand_path File.join(File.dirname(__FILE__), "..", "app_data")

Indocker.add_artifact(
  Indocker::Core::Artifacts::Local
    .new(:indocker_example_data)
    .setup( data_path )
)