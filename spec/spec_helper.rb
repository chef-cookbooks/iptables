require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true               # Use color in STDOUT
  config.formatter = :documentation # Use the specified formatter
  config.log_level = :error         # Avoid deprecation notice SPAM
end

# Coverage report
require 'simplecov'
SimpleCov.start

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }
