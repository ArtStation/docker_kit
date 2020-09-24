class Indocker::Compiler::ImageBuildDirCreator
  include Indocker::Import["compiler.template_dir_compiler"]
  include Indocker::Import["compiler.template_file_compiler"]
  include Indocker::Import["shell.bash_commands"]

  def create(shell, image, builds_dir)
  end
end