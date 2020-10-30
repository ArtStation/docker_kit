require "bundler/setup"

require 'simplecov'
SimpleCov.start

require "docker_kit"
require 'pry'
require 'dry/container/stub'

Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each { |f| require f }

FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

DockerKit::Container.enable_stubs!

DockerKit::Container.stub("tools.file_presence_checker", TestFilePresenceChecker.new)
DockerKit::Container.stub("core.image_definition_factory", TestImageDefinitionFactory.new)

DockerKit.set_debug_mode(true)

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
    DockerKit.set_configuration_name(:default)
  end

  config.after do
    DockerKit::Container['core.image_store'].reset!
    DockerKit::Container['core.service_store'].reset!
    DockerKit::Container['core.configuration_store'].reset!
    DockerKit::Container['core.registry_store'].reset!
    DockerKit::Container['core.artifact_store'].reset!
    DockerKit::Container['core.env_file_store'].reset!
    DockerKit::Container['core.template_store'].reset!
    DockerKit::Container['artifacts_sync.artifacts_updater'].reset!
    DockerKit::Container['env_file_reader.reader'].reset!
    DockerKit::Container['template_reader.reader'].reset!
    DockerKit::Container['tools.file_presence_checker'].reset!
  end
end

def test_helper
  TestHelper.new
end