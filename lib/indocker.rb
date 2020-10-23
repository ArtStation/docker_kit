require "indocker/version"
require 'ostruct'
require 'contracts'
require 'dry-auto_inject'
require 'indocker/extensions/colored_string'
require 'indocker/extensions/contracts'

$LOAD_PATH << File.join(__dir__, 'indocker')

module Indocker
  Error = Class.new(StandardError)
  NotImplementedError = Class.new(Error)
  NotFoundError = Class.new(Error)
  
  module Core
    autoload :ImageDefinition, 'core/image_definition'
    autoload :ImageDefinitionFactory, 'core/image_definition_factory'
    autoload :ImageStore, 'core/image_store'
    autoload :ImageFactory, 'core/image_factory'
    autoload :Image, 'core/image'

    autoload :ConfigurationDefinition, 'core/configuration_definition'
    autoload :ConfigurationDefinitionFactory, 'core/configuration_definition_factory'
    autoload :ConfigurationStore, 'core/configuration_store'
    autoload :ConfigurationFactory, 'core/configuration_factory'
    autoload :Configuration, 'core/configuration'

    module Registries
      autoload :AbstractRegistry, 'core/registries/abstract_registry'
      autoload :RegistryStore, 'core/registries/registry_store'
      autoload :Registry, 'core/registries/registry'
    end

    module Artifacts
      autoload :AbstractArtifact, 'core/artifacts/abstract_artifact'
      autoload :ArtifactStore, 'core/artifacts/artifact_store'
      autoload :Git, 'core/artifacts/git'
      autoload :Local, 'core/artifacts/local'
    end

    module EnvFiles
      autoload :EnvFileStore, 'core/env_files/env_file_store'
      autoload :AbstractEnvFile, 'core/env_files/abstract_env_file'
      autoload :ArtifactFile, 'core/env_files/artifact_file'
    end

    module Templates
      autoload :TemplateStore, 'core/templates/template_store'
      autoload :AbstractTemplate, 'core/templates/abstract_template'
      autoload :ErbTemplate, 'core/templates/erb_template'
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
    autoload :BashCommands, 'shell/bash_commands'
    autoload :DockerCommands, 'shell/docker_commands'
    autoload :GitCommands, 'shell/git_commands'
    autoload :RsyncCommands, 'shell/rsync_commands'
    autoload :CommandCounter, 'shell/command_counter'
  end

  module Compiler
    autoload :ImageBuilder, 'compiler/image_builder'
    autoload :ImageBuildDirCreator, 'compiler/image_build_dir_creator'
    autoload :ImageCompiler, 'compiler/image_compiler'
    autoload :ImageDependencyResolver, 'compiler/image_dependency_resolver'
    autoload :ContextHelper, 'compiler/context_helper'
    autoload :ContextHelperFactory, 'compiler/context_helper_factory'
    autoload :VersionTagBuilder, 'compiler/version_tag_builder'
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
    autoload :Reader, 'env_file_reader/reader'
    autoload :AbstractEnvFileReader, 'env_file_reader/abstract_env_file_reader'
    autoload :ArtifactFileReader, 'env_file_reader/artifact_file_reader'
  end

  module Actions
    autoload :ImageCompiler, 'actions/image_compiler'
    autoload :EnvFileReader, 'actions/env_file_reader'
    autoload :ConfigurationLoader, 'actions/configuration_loader'
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

    def build_helper(&proc)
      Indocker::Compiler::ContextHelper.class_exec(&proc)
    end
  end
end

require 'indocker/extensions/compat'