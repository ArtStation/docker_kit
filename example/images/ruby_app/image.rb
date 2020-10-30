KuberKit
  .define_image(:ruby_app)
  .registry(:default)
  .depends_on(:ruby, :app_sources)
  .before_build do |context_helper, build_dir|
    # copy file local artifact
    source_path = context_helper.artifact_path(:kuber_kit_example_data, "test.txt")
    target_path = File.join(build_dir, "test.txt")
    context_helper.shell.exec!("cp #{source_path} #{target_path}")

    # copy file local artifact
    source_path = context_helper.artifact_path(:kuber_kit_repo, "README.md")
    target_path = File.join(build_dir, "README.md")
    context_helper.shell.exec!("cp #{source_path} #{target_path}")
  end