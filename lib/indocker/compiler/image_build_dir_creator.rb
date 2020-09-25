class Indocker::Compiler::ImageBuildDirCreator
  include Indocker::Import["compiler.template_dir_compiler"]
  include Indocker::Import["compiler.template_file_compiler"]
  include Indocker::Import["shell.bash_commands"]
  include Indocker::Import["configs"]

  def create(shell, image, build_dir, context_helper: nil)
    bash_commands.rm_rf(shell, build_dir)
    bash_commands.mkdir_p(shell, build_dir)

    if image.build_context_dir
      template_dir_compiler.compile(
        shell, image.build_context_dir, build_dir,
        context_helper: context_helper
      )
    end

    target_dockerfile = File.join(build_dir, configs.image_dockerfile_name)
    template_file_compiler.compile(
      shell, image.dockerfile_path, 
      destination_path: target_dockerfile, 
      context_helper: context_helper
    )

    docker_ignore_content = configs.docker_ignore_list.join("\r\n")
    shell.write(File.join(build_dir, '.dockerignore'), docker_ignore_content)
  end
end