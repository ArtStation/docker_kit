require 'cli/ui'

class Indocker::Actions::ImageCompiler
  include Indocker::Import[
    "infrastructure.infra_store",
    "core.image_store",
    "compiler.image_compiler",
    "compiler.image_dependency_resolver",
    "shell.local_shell",
    "configs",
    "ui"
  ]

  def call(image_name, options)
    ::CLI::UI::StdoutRouter.enable

    ui.spin("Loading infrastructure") do |spinner|
      infra_store.add_registry(Indocker::Infrastructure::Registry.new(:default))
      spinner.update_title("Loaded infrastructure")
    end

    ui.spin("Loading image definitions") do |spinner|
      files = image_store.load_definitions(options[:images_path])
      spinner.update_title("Loaded #{files.count} image definitions")
    end

    build_id = generate_build_id

    compile_image_with_dependencies(image_name, build_id)
  end

  private
    def compile_image_with_dependencies(image_name, build_id)
      resolved_dependencies = []
      dependencies = image_dependency_resolver.get_next(image_name)
      while (dependencies - resolved_dependencies).any?
        dependencies.each do |dependency_name|
          compile_image(dependency_name, build_id)
        end
        resolved_dependencies += dependencies
        dependencies = image_dependency_resolver.get_next(image_name, resolved: resolved_dependencies)
      end

      compile_image(image_name, build_id)
    end

    def compile_image(image_name, build_id)
      compile_dir = generate_compile_dir(build_id: build_id)

      ui.spin("Compiling #{image_name}") do |spinner|
        image_compiler.compile(local_shell, image_name, compile_dir)
        spinner.update_title("Compiled #{image_name}")
      end
    end

    def generate_build_id
      Time.now.strftime("%H%M%S")
    end

    def generate_compile_dir(build_id:)
      File.join(configs.image_compile_dir, build_id)
    end
end