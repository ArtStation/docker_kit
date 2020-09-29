require 'thor'

class Indocker::CLI < Thor

  desc "compile IMAGE_NAME", "Compile image with IMAGE_NAME"
  method_option :images_path, :type => :string, :required => true
  def compile(image_name)
    Indocker::Container['actions.image_compiler'].call(image_name.to_sym, options)
  end

  def self.exit_on_failure?
    true
  end
end