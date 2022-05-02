class KuberKit::ImageCompiler::ActionHandler
  include KuberKit::Import[
    "image_compiler.compiler",
    "core.image_store",
    "tools.build_dir_cleaner",
    "configs",
  ]

  Contract KuberKit::Shell::AbstractShell, Symbol, String => Any
  def call(shell, image_name, build_id)
    parent_dir = get_image_compile_parent_dir_for_shell(shell)

    image = image_store.get_image(image_name)

    build_dir_cleaner.call(shell, parent_dir: parent_dir)
    
    compile_dir = generate_compile_dir(parent_dir: parent_dir, build_id: build_id)

    compiler.compile(shell, image, compile_dir)
  end

  private
    def generate_compile_dir(parent_dir:, build_id:)
      File.join(parent_dir, build_id)
    end

    def get_image_compile_parent_dir_for_shell(shell)
      if shell.is_a?(KuberKit::Shell::SshShell)
        configs.remote_image_compile_dir
      else
        configs.image_compile_dir
      end
    end
end