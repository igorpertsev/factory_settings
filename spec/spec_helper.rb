# frozen_string_literal: true

require "factory_settings"
require "factory_settings/name/generator"
require "factory_settings/storages/file"
require "factory_settings/storages/in_memory"
require "factory_settings/storages/base"
require "factory_settings/robot"
require "factory_settings/name_create_support"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
