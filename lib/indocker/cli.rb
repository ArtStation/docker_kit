require 'thor'
require 'cli/ui'

class Indocker::CLI < Thor

  desc "build IMAGE_NAME", "Build image with IMAGE_NAME"
  def build(image_name)
    CLI::UI::StdoutRouter.enable
    spin_group = ::CLI::UI::SpinGroup.new
    spin_group.add("Building #{image_name}") { |spinner| sleep 3.0; }
    spin_group.wait
  end

  def self.exit_on_failure?
    true
  end
end