require 'thor'
require 'cli/ui'

class Indocker::CLI < Thor

  desc "compile IMAGE_NAME", "Compile image with IMAGE_NAME"
  def compile(image_name)
    CLI::UI::StdoutRouter.enable
    spin_group = ::CLI::UI::SpinGroup.new
    spin_group.add("Building #{image_name}") { |spinner| sleep 3.0; }
    spin_group.wait

    #compiler = Indocker::Container['compiler.image_compiler']
    #compiler.compile()
  end

  def self.exit_on_failure?
    true
  end
end