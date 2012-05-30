APP_ENV = 'production'

require './app/bootstrap'
require './config/api_credentials'
require 'omniauth'
require 'omniauth-github'

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :github, LunchZone::GITHUB_CLIENT_ID,
                    LunchZone::GITHUB_CLIENT_SECRET
end

run LunchZone::App.new
