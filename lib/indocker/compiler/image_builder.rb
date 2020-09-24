class Indocker::Compiler::ImageBuilder
  include Indocker::Import["shell.docker_commands"]

  def build(shell, image, build_dir)
    docker_commands.build(shell, "/tmp/build/#{image.name}")
  end
end