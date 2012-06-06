module LunchZone
  class App < Sinatra::Application
    get '/' do
      if current_user
        erb :home
      else
        erb :sign_in
      end
    end

    get '/not-an-employee' do
      'You are either not an employee or you have your employee status concealed
       on the Github Partnerpedia organization. Enable it and sign in again.'
    end
  end
end
