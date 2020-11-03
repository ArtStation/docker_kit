class KuberKit::ImageCompiler::Compiler
  include KuberKit::Import[
    "image_compiler.image_build_dir_creator",
    "image_compiler.image_builder",
    "core.context_helper_factory",
  ]

  Contract KuberKit::Shell::AbstractShell, KuberKit::Core::Image, String => Any
  def compile(shell, image, builds_dir)
    image_build_dir = File.join(builds_dir, image.name.to_s)

    context_helper = context_helper_factory.build_image_context(shell)
    image_build_dir_creator.create(shell, image, image_build_dir, context_helper: context_helper)

    image_builder.build(shell, image, image_build_dir, context_helper: context_helper)
    image_build_dir_creator.cleanup(shell, image_build_dir)
  end
end