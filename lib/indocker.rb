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
  end

  autoload :Defaults, 'defaults'

  class Container
    extend Dry::Container::Mixin

    register "defaults" do
      Indocker::Defaults.new
    end

    register "core.image_factory" do
      Indocker::Core::ImageFactory.new
    end
    
    register "core.image_definition_factory" do
      Indocker::Core::ImageDefinitionFactory.new
    end

    register "tools.file_presence_checker" do
      Indocker::Tools::FilePresenceChecker.new
    end
  end

  Import = Dry::AutoInject(Container)
end