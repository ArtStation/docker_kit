require "bundler/setup"

require 'simplecov'
SimpleCov.start

require "indocker"
require 'pry'
require 'dry/container/stub'

Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each { |f| require f }

FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

Indocker::Container.enable_stubs!

Indocker::Container.stub("tools.file_presence_checker", TestFilePresenceChecker.new)
Indocker::Container.stub("core.image_definition_factory", TestImageDefinitionFactory.new)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  
  config.before do
    test_helper.configuration_store.define(:default)
    Indocker.set_configuration_name(:default)
  end

  config.after do
    Indocker::Container['core.image_store'].reset!
    Indocker::Container['core.configuration_store'].reset!
    Indocker::Container['core.registry_store'].reset!
    Indocker::Container['core.repository_store'].reset!
  end
end

def test_helper
  TestHelper.new
end