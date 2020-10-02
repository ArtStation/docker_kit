require "indocker/version"
require 'ostruct'
require 'contracts'
require 'dry-auto_inject'
require 'indocker/extensions/colored_string'
require 'indocker/extensions/contracts'

$LOAD_PATH << File.join(__dir__, 'indocker')

module Indocker
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

    autoload :InfraStore, 'core/infra_store'
    autoload :Registry, 'core/registry'
  end

  module Tools
    autoload :FilePresenceChecker, 'tools/file_presence_checker'
  end

  module Shell
    autoload :AbstractShell, 'shell/abstract_shell'
    autoload :LocalShell, 'shell/local_shell'
    autoload :BashCommands, 'shell/bash_commands'
    autoload :DockerCommands, 'shell/docker_commands'
  end

  module Compiler
    autoload :TemplateCompiler, 'compiler/template_compiler'
    autoload :TemplateFileCompiler, 'compiler/template_file_compiler'
    autoload :TemplateDirCompiler, 'compiler/template_dir_compiler'
    autoload :ImageBuilder, 'compiler/image_builder'
    autoload :ImageBuildDirCreator, 'compiler/image_build_dir_creator'
    autoload :ImageCompiler, 'compiler/image_compiler'
    autoload :ImageDependencyResolver, 'compiler/image_dependency_resolver'
  end

  module Actions
    autoload :ImageCompiler, 'actions/image_compiler'
    autoload :ConfigurationLoader, 'actions/configuration_loader'
  end

  module Extensions
    autoload :Inspectable, 'extensions/inspectable'
  end

  autoload :Configs, 'configs'
  autoload :CLI, 'cli'
  autoload :UI, 'ui'
  autoload :Container, 'container'

  Import = Dry::AutoInject(Container)

  class << self
    def define_image(image_name)
      image_path = caller[0].split(':').first
  
      Container["core.image_store"].define(image_name, image_path.split('image.rb').first)
    end
  end
end

require 'indocker/extensions/compat'