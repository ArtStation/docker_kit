require "indocker/version"
require 'ostruct'

$LOAD_PATH << File.join(__dir__, 'indocker')

module Indocker
  class Error < StandardError; end
  # Your code goes here...

  module Core
    autoload :ImageDefinition, 'core/image_definition'
  end
end