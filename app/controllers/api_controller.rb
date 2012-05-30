module LunchZone
  class App < Sinatra::Application
    get '/api/restaurants' do
      # returns json object like:
      # [ { :name => 'restaurant name' },
      #
    end

    post '/api/restaurants' do

    end

    post '/api/restaurants/:id/willing' do

    end

    post '/api/restaurants/:id/not-willing' do

    end
  end
end
