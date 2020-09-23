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

  class Container
    extend Dry::Container::Mixin

    register "image_factory" do
      Indocker::Core::ImageFactory.new
    end
    
    register "image_definition_factory" do
      Indocker::Core::ImageDefinitionFactory.new
    end
  end

  Import = Dry::AutoInject(Container)
end