require 'thor'

class Indocker::CLI < Thor

  desc "compile IMAGE_NAMES", "Compile image with IMAGE_NAMES (comma-separated)"
  method_option :path, :type => :string
  method_option :images_path, :type => :string
  method_option :infra_path, :type => :string
  method_option :configurations_path, :type => :string
  method_option :debug, :type => :boolean, aliases: ["-d"]

  method_option :configuration, :type => :string, aliases: ["-C"]
  def compile(image_names_str)
    Indocker.set_debug_mode(options[:debug])
    
    image_names = image_names_str.split(",").map(&:strip).map(&:to_sym)

    Indocker::Container['actions.configuration_loader'].call(options)
    Indocker::Container['actions.image_compiler'].call(image_names, options)

    logger = Indocker::Container['tools.logger']
    logger.info("---------------------------")
    logger.info("Image compilation finished!")
    logger.info("---------------------------")
  end

  desc "env ENV_FILE_NAME", "Return content of Env File ENV_FILE_NAME"
  method_option :path, :type => :string
  method_option :images_path, :type => :string
  method_option :infra_path, :type => :string
  method_option :configurations_path, :type => :string
  method_option :debug, :type => :boolean, aliases: ["-d"]
  method_option :configuration, :type => :string, aliases: ["-C"]
  def env(env_file_name)
    Indocker.set_debug_mode(options[:debug])

    Indocker::Container['actions.configuration_loader'].call(options)
    Indocker::Container['actions.env_file_reader'].call(env_file_name.to_sym, options)
  end

  desc "env TEMPLATE_NAME", "Return content of Template TEMPLATE_NAME"
  method_option :path, :type => :string
  method_option :images_path, :type => :string
  method_option :infra_path, :type => :string
  method_option :configurations_path, :type => :string
  method_option :debug, :type => :boolean, aliases: ["-d"]
  method_option :configuration, :type => :string, aliases: ["-C"]
  def template(template_name)
    Indocker.set_debug_mode(options[:debug])

    Indocker::Container['actions.configuration_loader'].call(options)
    Indocker::Container['actions.template_reader'].call(template_name.to_sym, options)
  end

  def self.exit_on_failure?
    true
  end
end