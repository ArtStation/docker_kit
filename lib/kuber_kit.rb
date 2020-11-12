require "kuber_kit/version"
require 'ostruct'
require 'contracts'
require 'dry-auto_inject'
require 'kuber_kit/extensions/colored_string'
require 'kuber_kit/extensions/contracts'

$LOAD_PATH << File.join(__dir__, 'kuber_kit')

module KuberKit
  Error = Class.new(StandardError)
  NotImplementedError = Class.new(Error)
  NotFoundError = Class.new(Error)
  
  module Core
    autoload :ImageDefinition, 'core/image_definition'
    autoload :ImageDefinitionFactory, 'core/image_definition_factory'
    autoload :ImageStore, 'core/image_store'
    autoload :ImageFactory, 'core/image_factory'
    autoload :Image, 'core/image'

    autoload :ServiceDefinition, 'core/service_definition'
    autoload :ServiceDefinitionFactory, 'core/service_definition_factory'
    autoload :ServiceStore, 'core/service_store'
    autoload :ServiceFactory, 'core/service_factory'
    autoload :Service, 'core/service'

    autoload :ConfigurationDefinition, 'core/configuration_definition'
    autoload :ConfigurationDefinitionFactory, 'core/configuration_definition_factory'
    autoload :ConfigurationStore, 'core/configuration_store'
    autoload :ConfigurationFactory, 'core/configuration_factory'
    autoload :Configuration, 'core/configuration'

    autoload :Store, 'core/store'

    module Artifacts
      autoload :AbstractArtifact, 'core/artifacts/abstract_artifact'
      autoload :ArtifactStore, 'core/artifacts/artifact_store'
      autoload :Git, 'core/artifacts/git'
      autoload :Local, 'core/artifacts/local'
    end

    module BuildServers
      autoload :AbstractBuildServer, 'core/build_servers/abstract_build_server'
      autoload :BuildServerStore, 'core/build_servers/build_server_store'
      autoload :BuildServer, 'core/build_servers/build_server'
    end

    module EnvFiles
      autoload :EnvFileStore, 'core/env_files/env_file_store'
      autoload :AbstractEnvFile, 'core/env_files/abstract_env_file'
      autoload :ArtifactFile, 'core/env_files/artifact_file'
    end

    module ContextHelper
      autoload :BaseHelper, 'core/context_helper/base_helper'
      autoload :ImageHelper, 'core/context_helper/image_helper'
      autoload :ServiceHelper, 'core/context_helper/service_helper'
      autoload :ContextHelperFactory, 'core/context_helper/context_helper_factory'
    end

    module Registries
      autoload :AbstractRegistry, 'core/registries/abstract_registry'
      autoload :RegistryStore, 'core/registries/registry_store'
      autoload :Registry, 'core/registries/registry'
    end

    module Templates
      autoload :TemplateStore, 'core/templates/template_store'
      autoload :AbstractTemplate, 'core/templates/abstract_template'
      autoload :ArtifactFile, 'core/templates/artifact_file'
    end
  end

  module Tools
    autoload :FilePresenceChecker, 'tools/file_presence_checker'
    autoload :LoggerFactory, 'tools/logger_factory'
    autoload :FilesSync, 'tools/files_sync'
  end

  module Shell
    autoload :AbstractShell, 'shell/abstract_shell'
    autoload :LocalShell, 'shell/local_shell'
    autoload :SshShell, 'shell/ssh_shell'
    autoload :CommandCounter, 'shell/command_counter'

    module Commands
      autoload :BashCommands, 'shell/commands/bash_commands'
      autoload :DockerCommands, 'shell/commands/docker_commands'
      autoload :GitCommands, 'shell/commands/git_commands'
      autoload :RsyncCommands, 'shell/commands/rsync_commands'
      autoload :KubectlCommands, 'shell/commands/kubectl_commands'
    end
  end

  module ImageCompiler
    autoload :ActionHandler, 'image_compiler/action_handler'
    autoload :BuildServerPool, 'image_compiler/build_server_pool'
    autoload :BuildServerPoolFactory, 'image_compiler/build_server_pool_factory'
    autoload :Compiler, 'image_compiler/compiler'
    autoload :ImageBuilder, 'image_compiler/image_builder'
    autoload :ImageBuildDirCreator, 'image_compiler/image_build_dir_creator'
    autoload :ImageDependencyResolver, 'image_compiler/image_dependency_resolver'
    autoload :VersionTagBuilder, 'image_compiler/version_tag_builder'
  end

  module Preprocessing
    autoload :TextPreprocessor, 'preprocessing/text_preprocessor'
    autoload :FilePreprocessor, 'preprocessing/file_preprocessor'
    autoload :DirPreprocessor, 'preprocessing/dir_preprocessor'
  end

  module ArtifactsSync
    autoload :AbstractArtifactResolver, 'artifacts_sync/abstract_artifact_resolver'
    autoload :ArtifactsUpdater, 'artifacts_sync/artifacts_updater'
    autoload :GitArtifactResolver, 'artifacts_sync/git_artifact_resolver'
    autoload :NullArtifactResolver, 'artifacts_sync/null_artifact_resolver'
  end

  module EnvFileReader
    autoload :ActionHandler, 'env_file_reader/action_handler'
    autoload :Reader, 'env_file_reader/reader'

    module Strategies
      autoload :Abstract, 'env_file_reader/strategies/abstract'
      autoload :ArtifactFile, 'env_file_reader/strategies/artifact_file'
    end
  end

  module TemplateReader
    autoload :Reader, 'template_reader/reader'
    autoload :AbstractTemplateReader, 'template_reader/abstract_template_reader'
    autoload :ArtifactFileReader, 'template_reader/artifact_file_reader'
  end

  module ServiceDeployer
    autoload :ActionHandler, 'service_deployer/action_handler'
    autoload :StrategyDetector, 'service_deployer/strategy_detector'
    autoload :Deployer, 'service_deployer/deployer'
    autoload :ServiceListResolver, 'service_deployer/service_list_resolver'

    module Strategies
      autoload :Abstract, 'service_deployer/strategies/abstract'
      autoload :Kubernetes, 'service_deployer/strategies/kubernetes'
    end
  end

  module ServiceReader
    autoload :ActionHandler, 'service_reader/action_handler'
    autoload :Reader, 'service_reader/reader'
  end

  module Actions
    autoload :ImageCompiler, 'actions/image_compiler'
    autoload :EnvFileReader, 'actions/env_file_reader'
    autoload :TemplateReader, 'actions/template_reader'
    autoload :ServiceReader, 'actions/service_reader'
    autoload :ServiceDeployer, 'actions/service_deployer'
    autoload :ConfigurationLoader, 'actions/configuration_loader'
    autoload :KubectlApplier, 'actions/kubectl_applier'
  end

  module Extensions
    autoload :Inspectable, 'extensions/inspectable'
  end

  module UI
    autoload :Interactive, 'ui/interactive'
    autoload :Simple, 'ui/simple'
  end

  autoload :Configs, 'configs'
  autoload :CLI, 'cli'
  autoload :Container, 'container'

  Import = Dry::AutoInject(Container)

  class << self
    def define_image(image_name)
      image_path = caller[0].split(':').first
  
      Container["core.image_store"].define(image_name, image_path.split('image.rb').first)
    end

    def define_service(service_name)  
      Container["core.service_store"].define(service_name)
    end

    def define_configuration(configuration_name)
      Container["core.configuration_store"].define(configuration_name)
    end

    def set_configuration_name(configuration_name)
      @configuration_name = configuration_name.to_sym
      @current_configuration = nil
    end

    def set_debug_mode(value)
      @debug_mode = value
    end
    
    def debug_mode?
      !!@debug_mode
    end

    def current_configuration
      if @configuration_name.nil?
        raise "Please set configuration name before calling current_configuration"
      end
      @current_configuration ||= Container['core.configuration_store'].get_configuration(@configuration_name)
    end

    def add_registry(registry)
      Container["core.registry_store"].add(registry)
    end

    def add_artifact(artifact)
      Container["core.artifact_store"].add(artifact)
    end

    def add_env_file(env_file)
      Container["core.env_file_store"].add(env_file)
    end

    def add_template(template)
      Container["core.template_store"].add(template)
    end

    def build_helper(&proc)
      KuberKit::Core::ContextHelper::BaseHelper.class_exec(&proc)
    end
  end
end

require 'kuber_kit/extensions/indocker_compat'