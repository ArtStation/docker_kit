require 'thor'

class Indocker::CLI < Thor

  desc "build IMAGE_NAME", "Build image with IMAGE_NAME"
  def build(image_name)
    puts "Building #{image_name}"
  end

  def self.exit_on_failure?
    true
  end
end