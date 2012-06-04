require_relative '../models/user'
require_relative '../models/restaurant'
require 'date'

module LunchZone
  class App < Sinatra::Application

    # [ { :name => 'restaurant name', :id => 1232 }, { ... } ]
    get '/api/restaurants' do
      Restaurant.all.map(&:attributes).to_json
    end

    # { :name => 'some name', :id => 123 }
    post '/api/restaurants' do
      Restaurant.create(:name => json_params[:name]).attributes.to_json
    end

    # [ { :name => 'restaurant name', :id => 1232,
    #     :users => [ {:nickname => '..', # :gravatar_id => 'id' }, { ... }, { ... } ],
    #   { ... } ]
    get '/api/restaurants/:date' do
      restaurant_data = Restaurant.all_for_date(Date.parse(params[:date]))

      restaurant_data.map { |data|
        user_attributes =  data[:users].map(&:public_attributes)

        data[:restaurant].public_attributes.merge(:users => user_attributes)
      }.to_json
    end

    # { :success => true }
    post '/api/restaurants/:id/:date/craving' do
      restaurant = Restaurant.get(params[:id])
      date       = Date.parse(params[:date])

      if current_user && restaurant
        current_user.new_craving(restaurant, date)
        {:success => true}.to_json
      else
        error 404, {:error => 'invalid parameters'}.to_json
      end
    end

    # { :success => true }
    post '/api/restaurants/:id/:date/not-craving' do
      restaurant = Restaurant.get(params[:id])
      date       = Date.parse(params[:date])

      if current_user && restaurant
        current_user.cravings.first(:date => date).try(:destroy)
        {:success => true}.to_json
      else
        error 404, {:error => 'invalid parameters'}.to_json
      end
    end
  end
end
