class Indocker::Compiler::ImageBuildDirCreator
  include Indocker::Import["compiler.template_dir_compiler"]
  include Indocker::Import["compiler.template_file_compiler"]
  include Indocker::Import["shell.bash_commands"]

  def create(shell, image, build_dir, context_helper: nil)
    bash_commands.rm_rf(shell, build_dir)
    bash_commands.mkdir_p(shell, build_dir)

    if image.build_context_dir
      template_dir_compiler.compile(
        shell, image.build_context_dir, build_dir,
        context_helper: context_helper
      )
    end
  end
end