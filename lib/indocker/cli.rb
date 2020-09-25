require 'thor'
require 'cli/ui'

class Indocker::CLI < Thor

  desc "compile IMAGE_NAME", "Compile image with IMAGE_NAME"
  method_option :images_path, :type => :string, :required => true
  def compile(image_name)
    #CLI::UI::StdoutRouter.enable

    shell    = Indocker::Container['shell.local_shell']
    compiler = Indocker::Container['compiler.image_compiler']
    image_store = Indocker::Container['core.image_store']

    #spinner("Loading definitions") do
      image_store.load_definitions(options[:images_path])
    #end

    #spinner("Compiling #{image_name}") do
      image = image_store.get_image(image_name.to_sym)
      compiler.compile(shell, image, "/tmp/images")
    #end
  end

  def self.exit_on_failure?
    true
  end

  no_commands do
    def spinner(title, &block)
      spin_group = ::CLI::UI::SpinGroup.new
      spin_group.add(title) do |spinner| 
        yield
      end
      spin_group.wait
    end
  end
end