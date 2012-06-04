require 'json'
require 'spec_helper'
require_relative '../app/app'
require_relative '../app/controllers/api_controller'
require 'rack/test'

module LunchZone
  describe 'service' do
    include Rack::Test::Methods

    let!(:hungryman) { User.create(:nickname => 'hungryman') }
    let!(:friend)    { User.create(:nickname => 'friend') }
    let!(:qq_sushi)  { Restaurant.create(:name => 'QQ Sushi') }
    let!(:memphis)   { Restaurant.create(:name => 'Memphis Grill') }

    def app
      App
    end

    def parsed_response
      JSON.parse(last_response.body)
    end

    before do
      app.class_eval do
        helpers do
          def current_user
            User.first(:nickname => 'hungryman')
          end
        end
      end
    end

    describe 'GET /api/restaurants' do
      it 'returns all restaurants' do
        get '/api/restaurants'

        last_response.should be_ok
        first_restaurant = parsed_response.first
        first_restaurant['name'].should == 'QQ Sushi'
      end
    end

    describe 'POST /api/restaurants' do
      it 'creates a new restaurant' do
        post '/api/restaurants', { :name => 'Some New One' }.to_json

        id = parsed_response['id']

        Restaurant.last.name.should == 'Some New One'
      end
    end

    describe 'POST /api/restaurants/:id/:date/craving' do
      before do
        app.stubs(:current_user).with(User.first)
      end

      it 'creates a craving for the given user' do
        restaurant_id = Restaurant.first.id
        nickname      = User.first.nickname

        date = '2012-01-01'
        post "/api/restaurants/#{restaurant_id}" +
             "/#{date}" +
             "/craving"

        last_response.should be_ok
        parsed_response['success'].should == true

        Craving.last.user.should       == User.first
        Craving.last.restaurant.should == Restaurant.first
        Craving.last.date.should       == Date.parse(date)
      end
    end

    describe 'POST /api/restaurants/:id/:date/not-craving' do
      before do
        app.stubs(:current_user).with(User.first)
        User.first.new_craving(Restaurant.first, Date.parse('2012-01-01'))
      end

      it 'should remove the specified craving if it exists' do
        Craving.count.should == 1

        restaurant_id = Restaurant.first.id
        nickname      = User.first.nickname

        date = '2012-01-01'
        post "/api/restaurants/#{restaurant_id}" +
             "/#{date}" +
             "/not-craving"

        last_response.should be_ok
        parsed_response['success'].should == true

        Craving.count.should == 0
      end
    end

    describe 'GET /api/restaurants/:date' do
      before do
        restaurant = Restaurant.first(:name => 'QQ Sushi')
        date       = Date.parse('2012-01-01')

        hungryman.new_craving(restaurant, date)
        friend.new_craving(restaurant, date)
      end

      it 'returns a list of restaurants including the people who crave it' do
        get '/api/restaurants/2012-01-01'

        qq_sushi_data = parsed_response.detect { |data|
          data['name'] == 'QQ Sushi'
        }

        memphis_grill_data = parsed_response.detect { |data|
          data['name'] == 'Memphis Grill'
        }

        qq_sushi_data['users'].length.should      == 2
        memphis_grill_data['users'].length.should == 0

        qq_sushi_data['users'].first['nickname'].should == 'hungryman'
      end
    end
  end
end
