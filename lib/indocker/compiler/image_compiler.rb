class Indocker::Compiler::ImageCompiler
  include Indocker::Import[
    "compiler.image_build_dir_creator",
    "compiler.image_builder",
    "core.image_store"
  ]

  def compile(shell, image_name, builds_dir)
    image = image_store.get_image(image_name)

    image_build_dir = File.join(builds_dir, image.name.to_s)

    image_build_dir_creator.create(shell, image, image_build_dir)
    image_builder.build(shell, image, image_build_dir, args: [])
  end
end