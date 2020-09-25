class Indocker::Compiler::ImageBuilder
  include Indocker::Import["shell.docker_commands"]

  def build(shell, image, build_dir, args: [])
    docker_commands.build(shell, build_dir, ["-t=#{image.registry_url}"])

    if image.registry.remote?
      docker_commands.tag(shell, image.registry_url, image.remote_registry_url)
    end
  end
end