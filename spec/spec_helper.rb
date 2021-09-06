require "bundler/setup"

require 'simplecov'
SimpleCov.start

require "kuber_kit"
require 'pry'
require 'dry/container/stub'

ENV['KUBER_KIT_CONFIGURATION'] = nil
ENV['KUBER_KIT_PATH'] = nil

Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each { |f| require f }

FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

KuberKit::Container.enable_stubs!

KuberKit::Container.stub("tools.file_presence_checker", TestFilePresenceChecker.new)
KuberKit::Container.stub("core.image_definition_factory", TestImageDefinitionFactory.new)

KuberKit.set_ui_mode(:simple)

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
    KuberKit.set_configuration_name(:default)
  end

  config.after do
    KuberKit::Container['core.image_store'].reset!
    KuberKit::Container['core.service_store'].reset!
    KuberKit::Container['core.configuration_store'].reset!
    KuberKit::Container['core.registry_store'].reset!
    KuberKit::Container['core.artifact_store'].reset!
    KuberKit::Container['core.env_file_store'].reset!
    KuberKit::Container['core.template_store'].reset!
    KuberKit::Container['core.build_server_store'].reset!
    KuberKit::Container['tools.file_presence_checker'].reset!
    KuberKit::Container['configs'].reset!
  end
end

def test_helper
  TestHelper.new
end

def service_helper
  ServiceHelper.new
end


def ssh_test_connection
  # ENV['SSH_TEST_ENABLED'] = "1"
  # ENV['SSH_TEST_HOST']    = "indocker.artstn.ninja"
  # ENV['SSH_TEST_USER']    = "kuber_kit"
  {
    enabled:  ENV['SSH_TEST_ENABLED'] == '1',
    host:     ENV['SSH_TEST_HOST'], 
    user:     ENV['SSH_TEST_USER'], 
    port:     22, 
    folder:   "/home/kuber_kit/kuber_kit"
  }
end