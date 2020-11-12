class KuberKit::ImageCompiler::ImageBuildDirCreator
  include KuberKit::Import[
    "preprocessing.dir_preprocessor",
    "preprocessing.file_preprocessor",
    "shell.bash_commands",
    "shell.local_shell",
    "configs"
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Image, String, KeywordArgs[
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

    # Upload dockerfile to build server and then preprocess
    target_dockerfile = File.join(build_dir, configs.image_dockerfile_name)
    shell.upload_file(image.dockerfile_path, target_dockerfile)
    file_preprocessor.compile(
      shell, target_dockerfile,
      context_helper: context_helper
    )

    docker_ignore_content = configs.docker_ignore_list.join("\r\n")
    shell.write(File.join(build_dir, '.dockerignore'), docker_ignore_content)
  end

  def cleanup(shell, build_dir)
    bash_commands.rm_rf(shell, build_dir)
  end
end