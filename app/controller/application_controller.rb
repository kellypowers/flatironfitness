require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base
    #register Sinatra::ActiveRecordExtension 
    configure do
      set :views, "app/views"
      enable :sessions
      set :session_secret, "secret"
      set :views, Proc.new { File.join(root, "../views/") }
      set :public_folder, 'public'
      #set :src_folder, 'src'
    end
  
    get '/' do
      if logged_in?
        redirect to "/users/home"
      else
        erb :home
      end
    end
  
    def current_user 
      @current_user ||= User.find_by_id(session[:user_id])
    end
  
    helpers do
      def logged_in?
        !!current_user
      end
  
  
    end
  end