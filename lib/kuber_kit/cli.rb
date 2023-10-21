require 'thor'

class KuberKit::CLI < Thor
  APP_CONFIG_FILENAME = "config.rb".freeze

  class_option :path, :type => :string
  class_option :images_path, :type => :string
  class_option :infra_path, :type => :string
  class_option :configurations_path, :type => :string
  class_option :ui, :type => :string, :desc => "UI mode (interactive|debug|simple)"
  class_option :debug, :type => :boolean, aliases: ["-d"]
  class_option :configuration, :type => :string, aliases: ["-C"]
  class_option :user, :type => :string, aliases: ["-u"]
  class_option :use_local_deploy, :type => :boolean, aliases: ["-l"]

  desc "compile IMAGE_NAMES", "Compile image with IMAGE_NAMES (comma-separated)"
  def compile(image_names_str)
    setup(options)
    
    started_at = Time.now.to_i
    image_names = image_names_str.split(",").map(&:strip).map(&:to_sym)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      action_result = KuberKit::Container['actions.image_compiler'].call(image_names, options)
    end

    clean_artifacts(options)

    if action_result && action_result.succeeded?
      time = (Time.now.to_i - started_at)
      print_result("Image compilation finished! (#{time}s)", result: {
        images:       action_result.finished_tasks,
        compilation:  action_result.all_results
      })
    else
      exit 1
    end
  end

  desc "deploy -t TAG_NAME", "Deploy CONTEXT_NAME with kubectl"
  method_option :services,              :type => :array,    aliases: ["-s"], repeatable: true
  method_option :tags,                  :type => :array,    aliases: ["-t"], repeatable: true
  method_option :skip_services,         :type => :array,    aliases: ["-S"], repeatable: true
  method_option :skip_compile,          :type => :boolean,  aliases: ["-B"]
  method_option :skip_dependencies,     :type => :boolean,  aliases: ["-D"]
  method_option :require_confirmation,  :type => :boolean,  aliases: ["-r"]
  method_option :skip_confirmation,     :type => :boolean,  aliases: ["-R"]
  method_option :skip_deployment,       :type => :boolean,  aliases: ["-K"]
  def deploy
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      require_confirmation = options[:require_confirmation] || 
                             KuberKit.current_configuration.deployer_require_confirmation ||
                             false
      require_confirmation = false if options[:skip_confirmation]
      started_at = Time.now.to_i
      action_result = KuberKit::Container['actions.service_deployer'].call(
        services:             (options[:services] || []).flatten.uniq, 
        tags:                 (options[:tags] || []).flatten.uniq,
        skip_services:        (options[:skip_services] || []).flatten.uniq, 
        skip_compile:         options[:skip_compile] || false,
        skip_dependencies:    options[:skip_dependencies] || false,
        skip_deployment:      options[:skip_deployment] || false,
        require_confirmation: require_confirmation
      )
    end

    clean_artifacts(options)

    if action_result && action_result.succeeded?
      time = (Time.now.to_i - started_at)
      print_result("Service deployment finished! (#{time}s)", result: {
        services:   action_result.finished_tasks, 
        deployment: action_result.all_results
      })
    else
      exit 1
    end
  end

  desc "envfile ENV_FILE_NAME", "Return content of Env File ENV_FILE_NAME"
  def envfile(env_file_name)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      KuberKit::Container['actions.env_file_reader'].call(env_file_name.to_sym, options)
    end
  end

  desc "template TEMPLATE_NAME", "Return content of Template TEMPLATE_NAME"
  def template(template_name)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      KuberKit::Container['actions.template_reader'].call(template_name.to_sym, options)
    end
  end

  desc "service SERVICE_NAME", "Return content of Service SERVICE_NAME"
  def service(service_name)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      KuberKit::Container['actions.service_reader'].call(service_name.to_sym, options)
    end
  end

  desc "check", "Check to make sure that all services are deployed"
  def check()
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      KuberKit::Container['actions.service_checker'].call(options)
    end
  end


  desc "generate SERVICE_NAME PATH_NAME", "Generates a template for a given service in a given path"
  def generate(service_name, path)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      KuberKit::Container['actions.service_generator'].call(service_name.to_sym, path)
    end
  end

  desc "apply FILE_PATH", "Apply FILE_PATH with kubectl"
  def apply(file_path)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      KuberKit::Container['actions.kubectl_applier'].call(File.expand_path(file_path), options)
    end
  end

  desc "attach POD_NAME", "Attach to POD_NAME using kubectl"
  def attach(pod_name = nil)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options)
      KuberKit::Container['actions.kubectl_attacher'].call(pod_name, options)
    end
  end

  desc "console POD_NAME", "Attach to POD_NAME using kubectl & launch bin/console"
  def console(pod_name = nil)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options.merge(load_inventory: false))
      KuberKit::Container['actions.kubectl_console'].call(pod_name, options)
    end
  end

  desc "logs POD_NAME", "Show logs for POD_NAME using kubectl"
  method_option :follow,  :type => :boolean,  aliases: ["-f"]
  def logs(pod_name = nil)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options.merge(load_inventory: false))
      KuberKit::Container['actions.kubectl_logs'].call(pod_name, options)
    end
  end

  desc "describe RESOURCE_NAME", "Show description for RESOURCE_NAME using kubectl"
  def describe(pod_name = nil)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options.merge(load_inventory: false))
      KuberKit::Container['actions.kubectl_describe'].call(pod_name, options)
    end
  end

  desc "env", "Show environment variables for given configuration"
  def env()
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options.merge(load_inventory: false))
      KuberKit::Container['actions.kubectl_env'].call(options)
    end
  end

  desc "sh", "Create a new shell with KUBECONFIG env variable in place"
  def sh()
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options.merge(load_inventory: false))
      KuberKit::Container['actions.shell_launcher'].call()
    end
  end

  desc "get RESOURCE_NAME", "List pods matching RESOURCE_NAME using kubectl"
  def get(pod_name = nil)
    setup(options)

    if KuberKit::Container['actions.configuration_loader'].call(options.merge(load_inventory: false))
      pods = KuberKit::Container['actions.kubectl_get'].call(pod_name, options)

      print_result("Fetched list of pods", result: {
        pods: pods
      })
    end
  end

  desc "version", "Print current version"
  def version
    puts KuberKit::VERSION
  end

  def self.exit_on_failure?
    true
  end

  private
    def setup(options)
      if options[:debug]
        KuberKit.set_ui_mode(:debug)
      elsif options[:ui]
        KuberKit.set_ui_mode(options[:ui].to_sym)
      end

      if options[:user]
        KuberKit.set_user(options[:user])
      end

      # We should load config before loading any bean, to make sure that bean won't be built with default config
      root_path = KuberKit::Container['tools.workdir_detector'].call(options)
      config_file_path = File.join(root_path, APP_CONFIG_FILENAME)
      if File.exist?(config_file_path)
        require config_file_path
      end
    end

    def print_result(message, data = {})
      KuberKit::Container['ui'].print_result(message, data)
    end

    def clean_artifacts(options)
      artifacts = KuberKit.current_configuration.artifacts.values
      artifacts_to_clean = artifacts.select(&:cleanup_needed?)
  
      return unless artifacts_to_clean.any?

      artifacts_to_clean.each do |artifact|
        KuberKit::Container['artifacts_sync.artifact_updater'].cleanup(
          KuberKit::Container['shell.local_shell'], artifact
        )
      end
    end
end