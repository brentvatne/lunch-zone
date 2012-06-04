require_relative '../models/user'
require_relative '../models/restaurant'
require 'date'

module LunchZone
  class App < Sinatra::Application

    # [ { :name => 'restaurant name', :id => 1232 }, { ... } ]
    get '/api/restaurants' do
      Restaurant.all.map(&:attributes).to_json
    end

    # { :name => 'restaurant name', :id => 1232 }
    get '/api/restaurants/:id' do
      restaurant = Restaurant.get(params[:id])

      if restaurant
        restaurant.attributes.to_json
      else
        error 404, {:error => 'restaurant not found'}.to_json
      end
    end

    # { :name => 'some name', :id => 123, :people => [] }
    post '/api/restaurants' do
      Restaurant.create(:name => json_params[:name]).attributes.to_json
    end

    # [ { :name => 'restaurant name', :id => 1232,
    #     :people => [ {:nickname => '..', # :gravatar_id => 'id' }, { ... }, { ... } ],
    #   { ... } ]
    get '/api/restaurants/on/:date' do
      restaurant_data = Restaurant.all_for_date(Date.parse(params[:date]))

      restaurant_data.map { |data|
        { :restaurant => data[:restaurant].public_attributes,
          :users      => data[:users].map(&:public_attributes) }
      }.to_json
    end

    # { :success => true }
    post '/api/users/:nickname/restaurants/:id/:date/craving' do
      user       = User.first(:nickname => params[:nickname])
      restaurant = Restaurant.get(params[:id])
      date       = Date.parse(params[:date])

      if user && restaurant
        user.new_craving(restaurant, date)
        {:success => true}.to_json
      else
        error 404, {:error => 'invalid parameters'}.to_json
      end
    end

    # { :success => true }
    post '/api/users/:nickname/restaurants/:id/:date/not-craving' do
    end
  end
end
