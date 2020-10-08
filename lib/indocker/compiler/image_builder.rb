class Indocker::Compiler::ImageBuilder
  include Indocker::Import["shell.docker_commands"]

  Contract Indocker::Shell::AbstractShell, Indocker::Core::Image, String, KeywordArgs[
    args: Maybe[Any],
    context_helper: Maybe[Indocker::Compiler::ContextHelper]
  ] => Any
  def build(shell, image, build_dir, context_helper: nil, args: [])
    image.before_build_callback.call(context_helper, build_dir) if image.before_build_callback

    docker_commands.build(shell, build_dir, ["-t=#{image.registry_url}"])

    if image.registry.remote?
      docker_commands.tag(shell, image.registry_url, image.remote_registry_url)
      docker_commands.push(shell, image.remote_registry_url)
    end

    image.after_build_callback.call(context_helper, build_dir) if image.after_build_callback
  end
end