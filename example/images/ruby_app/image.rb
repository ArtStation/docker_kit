Indocker
  .define_image(:ruby_app)
  .registry(:default)
  .depends_on(:ruby, :app_sources)
  .before_build do |context_helper, build_dir|
    files = %w(
      test.txt
    )

    files.each do |file|
      source_path = context_helper.artifact_path(:indocker_example_data, file)
      target_path = File.join(build_dir, file)
      context_helper.shell.exec!("cp #{source_path} #{target_path}")
    end
  end