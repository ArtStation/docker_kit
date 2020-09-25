class Indocker::Compiler::ImageCompiler
  include Indocker::Import[
    "compiler.image_build_dir_creator",
    "compiler.image_builder"
  ]

  def compile(shell, image, builds_dir)
  end
end