module LunchZone
  class App < Sinatra::Application
    get '/' do
      if current_user
        erb :home
      else
        erb :sign_in
      end
    end
  end
end
