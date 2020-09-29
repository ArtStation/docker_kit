require 'cli/ui'

class Indocker::Actions::ImageCompiler
  include Indocker::Import[
    "infrastructure.infra_store",
    "core.image_store",
    "compiler.image_compiler",
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

    image = image_store.get_image(image_name.to_sym)

    image.dependent_images.each do |image|
      compile_image(image.name)
    end

    compile_image(image.name)
  end

  private
    def compile_image(image)
      ui.spin("Compiling #{image.name.to_sym}") do |spinner|
        image_compiler.compile(local_shell, image, "/tmp/images")
        spinner.update_title("Compiled #{image.name.to_sym}")
      end
    end
end