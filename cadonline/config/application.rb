require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Cadonline
  class Application < Rails::Application
    config.load_defaults 8.1

    config.generators.system_tests = nil

    config.exceptions_app = routes
  end
end
