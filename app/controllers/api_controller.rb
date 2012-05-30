module LunchZone
  class App < Sinatra::Application
    get '/api/restaurants' do
      # [ { :name => 'restaurant name', :id => 1232 }, { ... } ]
    end

    get '/api/restaurants/:date' do
      # [ { :name => 'restaurant name', :id => 1232,
      #     :people => [ {:nickname => '..', # :image => 'image_url' }, { ... }, { ... } ],
      #   { ... } ]
    end

    post '/api/restaurants' do
      # { :name => 'some name', :id => 123, :people => [] }
    end

    post '/api/restaurants/:id/willing' do
      # { :success => true }
    end

    post '/api/restaurants/:id/not-willing' do
      # { :success => true }
    end
  end
end
