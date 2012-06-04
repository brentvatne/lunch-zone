require_relative '../models/user'
require_relative '../models/restaurant'

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
    #     :people => [ {:nickname => '..', # :image => 'image_url' }, { ... }, { ... } ],
    #   { ... } ]
    get '/api/restaurants/:date' do
    end

    post '/api/restaurants/:id/willing' do
      # { :success => true }
    end

    post '/api/restaurants/:id/not-willing' do
      # { :success => true }
    end
  end
end
