require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base
    #register Sinatra::ActiveRecordExtension 
    configure do
      set :views, "app/views"
      enable :sessions
      set :session_secret, "fitnessprogress"
      set :views, Proc.new { File.join(root, "../views/") }
      set :public_folder, 'public'
      #set :src_folder, 'src'
    end
  
    get '/' do
      if logged_in?
        redirect to "/users/#{@current_user.id}"
      else
        erb :'/home'
      end
    end
  
    def current_user 
      @current_user ||= User.find_by_id(session[:user_id])
    end
  
    helpers do
      def logged_in?
        !!current_user
      end
      
      def empty_fields?(hash)
        hash.values.any? {|x| x.nil? || x.empty?}
      end
  
    end
  end