require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '14.04'
end

at_exit { ChefSpec::Coverage.report! }
