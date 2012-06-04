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

    def parsed_response
      JSON.parse(last_response.body)
    end

    before do
      Restaurant.create(:name => 'QQ Sushi')
      Restaurant.create(:name => 'Memphis Grill')
    end

    describe 'GET /api/restaurants' do
      it 'returns all restaurants' do
        get '/api/restaurants'

        last_response.should be_ok
        first_restaurant = parsed_response.first
        first_restaurant['name'].should == 'QQ Sushi'
      end
    end

    describe 'GET /api/restaurants/:id' do
      it 'returns info for the restaurant with the given id' do
        get "/api/restaurants/#{Restaurant.first.id}"

        last_response.should be_ok
        parsed_response['name'].should == Restaurant.first.name
      end

      it 'returns 404 with an error message if not found' do
        get '/api/restaurants/this-is-so-wrong!!!!'

        last_response.status.should == 404
        parsed_response['error'].should match(/not found/)
      end
    end

    describe 'POST /api/restaurants' do
      it 'creates a new restaurant' do
        post '/api/restaurants', { :name => 'Some New One' }.to_json

        id = parsed_response['id']

        get "/api/restaurants/#{id}"
        parsed_response['name'].should == 'Some New One'
      end
    end
  end
end
