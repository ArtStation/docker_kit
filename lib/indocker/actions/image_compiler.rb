require 'cli/ui'

class Indocker::Actions::ImageCompiler
  include Indocker::Import[
    "infrastructure.infra_store",
    "core.image_store",
    "compiler.image_compiler",
    "compiler.image_dependency_resolver",
    "shell.local_shell",
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

    resolved_dependencies = []
    dependencies = image_dependency_resolver.get_next(image_name)
    while (dependencies - resolved_dependencies).any?
      dependencies.each do |dependency_name|
        compile_image(dependency_name)
      end
      resolved_dependencies += dependencies
      dependencies = image_dependency_resolver.get_next(image_name, resolved: resolved_dependencies)
    end

    compile_image(image_name)
  end

  private
    def compile_image(image_name)
      ui.spin("Compiling #{image_name}") do |spinner|
        image_compiler.compile(local_shell, image_name, "/tmp/images")
        spinner.update_title("Compiled #{image_name}")
      end
    end
end