require 'thor'

class Indocker::CLI < Thor

  desc "compile IMAGE_NAMES", "Compile image with IMAGE_NAMES (comma-separated)"
  method_option :images_path, :type => :string, :required => true
  def compile(image_names_str)
    image_names = image_names_str.split(",").map(&:strip).map(&:to_sym)

    Indocker::Container['ui'].init
    Indocker::Container['actions.configuration_loader'].call(options)
    Indocker::Container['actions.image_compiler'].call(image_names, options)
  end

  def self.exit_on_failure?
    true
  end
end