require_relative '../app'

module LunchZone
  class App < Sinatra::Application

    get '/auth/:provider/callback' do
      user          = User.find_or_create_from_omniauth(omniauth_params)
      session[:uid] = user.email

      omniauth_params.inspect
      # **********************************
      # Uncomment out the following line and fill in the path that you
      # would like to redirect to when the user has successfully logged in:
      #
      # redirect to('/some_signed_in_path')
    end

    get '/auth/failure' do
      content_type 'text/plain'
      "Sorry, something has gone wrong with the authentication process!"
    end

    # Logs the user out by resetting their UID
    get '/sign_out' do
      session[:uid]  = ""
      flash[:notice] = "You have been signed out! See you again soon."
      redirect to('/')
    end

    # A condition that can be added to Sinatra app class methods, as follows:
    # get '/', :authenticates => true { .. }
    set(:authenticates) do |required|
      condition { authenticate if required }
    end

    private

    # Instantiates the API client and makes it available to the local thread,
    # or initiates the authroization process if the user is not already
    # authorized
    def authenticate
      if user_has_session_cookie? and user_in_database?
        Thread.current['uid'] = session[:uid]
      else
        unless authentication_in_progress?
          redirect '/auth/google_oauth2', 303
        end
      end
    end

    def user_has_session_cookie?
      !!session[:uid]
    end

    def user_in_database?
      current_user
    end

    def current_user
      @current_user ||= User.first(:email => session[:uid])
    end

    # Private: Examines the path to determine if authorization is taking place
    #
    # Returns true if authorization is in progress, or false otherwise
    def authentication_in_progress?
      request.path_info =~ /^\/oauth/
    end

    # Private: Returns the Omniauth parameters hash
    def omniauth_params
     request.env['omniauth.auth'].to_hash
    end
  end
end
