require "bundler/setup"
require "indocker"

Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each { |f| require f }

FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def test_helper
  TestHelper.new
end