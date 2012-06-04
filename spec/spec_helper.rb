APP_ENV = 'test'

require 'rspec'
require 'sinatra/base'
require_relative '../config/data_mapper'

module LunchZone
  class App < Sinatra::Application
    set :environment, :test
  end
end

RSpec.configure do |config|
  config.before(:each) { DataMapper.auto_migrate! }
  config.mock_with :mocha
end
