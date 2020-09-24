class Indocker::Compiler::ImageCompiler
  include Indocker::Import["compiler.template_dir_compiler"]
  include Indocker::Import["compiler.template_file_compiler"]
  include Indocker::Import["compiler.image_builder"]
  include Indocker::Import["shell.bash_commands"]

  def compile(shell, image, builds_dir)
    compile_dir = File.join(builds_dir, image.name.to_s)
    bash_commands.rm_rf(shell, compile_dir)
    bash_commands.mkdir_p(shell, compile_dir)

    if image.build_context_dir
      template_dir_compiler.compile(
        shell, image.build_context_dir, compile_dir,
        context_helper: nil
      )
    end
  end
end