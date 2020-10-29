require 'thor'

class Indocker::CLI < Thor
  class_option :path, :type => :string
  class_option :images_path, :type => :string
  class_option :infra_path, :type => :string
  class_option :configurations_path, :type => :string
  class_option :debug, :type => :boolean, aliases: ["-d"]
  class_option :configuration, :type => :string, aliases: ["-C"]

  desc "compile IMAGE_NAMES", "Compile image with IMAGE_NAMES (comma-separated)"
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
  def env(env_file_name)
    Indocker.set_debug_mode(options[:debug])

    Indocker::Container['actions.configuration_loader'].call(options)
    Indocker::Container['actions.env_file_reader'].call(env_file_name.to_sym, options)
  end

  desc "template TEMPLATE_NAME", "Return content of Template TEMPLATE_NAME"
  def template(template_name)
    Indocker.set_debug_mode(options[:debug])

    Indocker::Container['actions.configuration_loader'].call(options)
    Indocker::Container['actions.template_reader'].call(template_name.to_sym, options)
  end

  desc "service SERVICE_NAME", "Return content of Service SERVICE_NAME"
  def service(service_name)
    Indocker.set_debug_mode(options[:debug])

    Indocker::Container['actions.configuration_loader'].call(options)
    Indocker::Container['actions.service_reader'].call(service_name.to_sym, options)
  end

  desc "apply FILE_PATH", "Apply FILE_PATH with kubectl"
  def apply(file_path)
    Indocker.set_debug_mode(options[:debug])

    Indocker::Container['actions.configuration_loader'].call(options)
    Indocker::Container['actions.kubectl_applier'].call(file_path, options)
  end

  def self.exit_on_failure?
    true
  end
end