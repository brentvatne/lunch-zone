require 'json'
require 'spec_helper'
require_relative '../app/app'
require_relative '../app/controllers/api_controller'
require 'rack/test'

module LunchZone
  describe 'service' do
    include Rack::Test::Methods

    def app
      App
    end

    describe 'GET /api/restaurants' do
      before do
        Restaurant.create(:name => 'QQ Sushi')
        Restaurant.create(:name => 'Memphis Grill')
      end

      it 'gets all restaurants' do
        get '/api/restaurants'
        last_response.should be_ok
        attributes = JSON.parse(last_response.body)
        first_restaurant = attributes.first
        first_restaurant['name'].should == 'QQ Sushi'
      end
    end
  end
end
