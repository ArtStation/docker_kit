class Indocker::Compiler::ImageCompiler
  include Indocker::Import[
    "compiler.image_build_dir_creator",
    "compiler.image_builder"
  ]

  def compile(shell, image, builds_dir)
    image_build_dir = File.join(builds_dir, image.name.to_s)

    image_build_dir_creator.create(shell, image, image_build_dir)
    image_builder.build(shell, image, image_build_dir, args: [])
  end
end