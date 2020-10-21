class Indocker::Compiler::ImageBuildDirCreator
  include Indocker::Import[
    "preprocessing.dir_preprocessor",
    "preprocessing.file_preprocessor",
    "shell.bash_commands",
    "configs"
  ]

  Contract Indocker::Shell::AbstractShell, Indocker::Core::Image, String, KeywordArgs[
    context_helper: Maybe[Any]
  ] => Any
  def create(shell, image, build_dir, context_helper: nil)
    bash_commands.rm_rf(shell, build_dir)
    bash_commands.mkdir_p(shell, build_dir)

    if image.build_context_dir
      dir_preprocessor.compile(
        shell, image.build_context_dir, build_dir,
        context_helper: context_helper
      )
    end

    target_dockerfile = File.join(build_dir, configs.image_dockerfile_name)
    file_preprocessor.compile(
      shell, image.dockerfile_path, 
      destination_path: target_dockerfile, 
      context_helper: context_helper
    )

    docker_ignore_content = configs.docker_ignore_list.join("\r\n")
    shell.write(File.join(build_dir, '.dockerignore'), docker_ignore_content)
  end

  def cleanup(shell, build_dir)
    bash_commands.rm_rf(shell, build_dir)
  end
end