require 'thor'

class Indocker::CLI < Thor

  desc "compile IMAGE_NAMES", "Compile image with IMAGE_NAMES (comma-separated)"
  method_option :images_path, :type => :string, :required => true
  def compile(image_names_str)
    image_names = image_names_str.split(",").map(&:strip).map(&:to_sym)

    infra_store = Indocker::Container['infrastructure.infra_store']
    image_store = Indocker::Container['core.image_store']
    ui = Indocker::Container['ui']
    ui.init

    ui.create_task("Loading infrastructure") do |task|
      infra_store.add_registry(Indocker::Infrastructure::Registry.new(:default))
      task.update_title("Loaded infrastructure")
    end

    ui.create_task("Loading image definitions") do |task|
      files = image_store.load_definitions(options[:images_path])
      task.update_title("Loaded #{files.count} image definitions")
    end

    Indocker::Container['actions.image_compiler'].call(image_names, options)
  end

  def self.exit_on_failure?
    true
  end
end