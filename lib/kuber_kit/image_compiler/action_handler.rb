class KuberKit::ImageCompiler::ActionHandler
  include KuberKit::Import[
    "image_compiler.compiler",
    "core.image_store",
    "tools.build_dir_cleaner",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol, String => Any
  def call(shell, image_name, build_id)
    image = image_store.get_image(image_name)

    build_dir_cleaner.call(parent_dir: configs.image_compile_dir)
    
    compile_dir = generate_compile_dir(build_id: build_id)

    compiler.compile(shell, image, compile_dir)
  end

  private
    def generate_compile_dir(build_id:)
      File.join(configs.image_compile_dir, build_id)
    end
end