require "indocker/version"
require 'ostruct'

require 'dry-types'
require 'dry-struct'
require 'dry-auto_inject'
module Types
  include Dry.Types()
end

$LOAD_PATH << File.join(__dir__, 'indocker')

module Indocker
  module Core
    autoload :ImageDefinition, 'core/image_definition'
    autoload :ImageDefinitionFactory, 'core/image_definition_factory'
    autoload :ImageStore, 'core/image_store'
    autoload :ImageFactory, 'core/image_factory'
    autoload :Image, 'core/image'
  end

  module Tools
    autoload :FilePresenceChecker, 'tools/file_presence_checker'
  end

  module Shell
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
  end

  autoload :Configs, 'configs'
  autoload :CLI, 'cli'

  class Container
    extend Dry::Container::Mixin

    register "configs" do
      Indocker::Configs.new
    end

    register "core.image_factory" do
      Indocker::Core::ImageFactory.new
    end
    
    register "core.image_definition_factory" do
      Indocker::Core::ImageDefinitionFactory.new
    end

    register "core.image_store" do
      Indocker::Core::ImageStore.new
    end

    register "tools.file_presence_checker" do
      Indocker::Tools::FilePresenceChecker.new
    end

    register "shell.bash_commands" do
      Indocker::Shell::BashCommands.new
    end

    register "shell.docker_commands" do
      Indocker::Shell::DockerCommands.new
    end

    register "shell.local_shell" do
      Indocker::Shell::LocalShell.new
    end

    register "compiler.template_compiler" do
      Indocker::Compiler::TemplateCompiler.new
    end

    register "compiler.template_file_compiler" do
      Indocker::Compiler::TemplateFileCompiler.new
    end

    register "compiler.template_dir_compiler" do
      Indocker::Compiler::TemplateDirCompiler.new
    end

    register "compiler.image_builder" do
      Indocker::Compiler::ImageBuilder.new
    end

    register "compiler.image_build_dir_creator" do
      Indocker::Compiler::ImageBuildDirCreator.new
    end

    register "compiler.image_compiler" do
      Indocker::Compiler::ImageCompiler.new
    end
  end

  Import = Dry::AutoInject(Container)

  class << self
    def define_image(image_name)
      image_path = caller[0].split(':').first
  
      Container["core.image_store"].define(image_name, image_path.split('image.rb').first)
    end
  end
end