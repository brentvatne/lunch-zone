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
      User.create(:nickname => 'hungryman')
      User.create(:nickname => 'friend')
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

    describe 'POST /api/users/:nickname/restaurants/:id/:date/craving' do
      it 'creates a craving for the given user' do
        restaurant_id = Restaurant.first.id
        nickname      = User.first.nickname

        date = '2012-01-01'
        post "/api/users/#{nickname}" +
             "/restaurants/#{restaurant_id}" +
             "/#{date}" +
             "/craving"

        last_response.should be_ok
        parsed_response['success'].should == true

        Craving.last.user.should       == User.first
        Craving.last.restaurant.should == Restaurant.first
        Craving.last.date.should       == Date.parse(date)
      end
    end

    describe 'POST /api/users/:nickname/restaurants/:id/:date/not-craving' do
      it '' do

      end
    end

    describe 'GET /api/restaurants/:date' do
      before do
        restaurant_id = Restaurant.first(:name => 'QQ Sushi').id
        date          = '2012-01-01'

        ['hungryman', 'friend'].each do |nickname|
          post "/api/users/#{nickname}" +
               "/restaurants/#{restaurant_id}" +
               "/#{date}" +
               "/craving"
        end
      end

      it 'returns a list of restaurants including the people who crave it' do
        get '/api/restaurants/on/2012-01-01'

        qq_sushi = parsed_response.detect { |data|
          data['restaurant']['name'] == 'QQ Sushi'
        }

        memphis_grill = parsed_response.detect { |data|
          data['restaurant']['name'] == 'Memphis Grill'
        }

        qq_sushi['users'].length.should      == 2
        memphis_grill['users'].length.should == 0

        qq_sushi['users'].first['nickname'].should == 'hungryman'
      end
    end
  end
end
