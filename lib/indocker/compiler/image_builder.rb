class Indocker::Compiler::ImageBuilder
  include Indocker::Import["shell.docker_commands"]

  def build(shell, image, build_dir, args: [])
    docker_commands.build(shell, build_dir)
  end
end