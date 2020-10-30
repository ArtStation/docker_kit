class DockerKit::ImageCompiler::Compiler
  include DockerKit::Import[
    "image_compiler.image_build_dir_creator",
    "image_compiler.image_builder",
    "core.context_helper_factory",
    "core.image_store"
  ]

  Contract DockerKit::Shell::AbstractShell, Symbol, String => Any
  def compile(shell, image_name, builds_dir)
    image = image_store.get_image(image_name)

    image_build_dir = File.join(builds_dir, image.name.to_s)

    context_helper = context_helper_factory.build_image_context(shell)
    image_build_dir_creator.create(shell, image, image_build_dir, context_helper: context_helper)

    image_builder.build(shell, image, image_build_dir, context_helper: context_helper, args: [])
    image_build_dir_creator.cleanup(shell, image_build_dir)
  end
end