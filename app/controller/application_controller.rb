require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "fitnessprogress"
    set :views, Proc.new { File.join(root, "../views/") }
    set :public_folder, 'public'
    # set :show_exceptions, false
  end

  get '/' do
    redirect to '/users/home'
  end

  # error do 
  #   redirect '/'
  # end


  def current_user 
    @current_user ||= User.find_by_id(session[:user_id])
  end

  helpers do
    def logged_in?
      !!current_user
    end
    
    def total_minutes_towards_goal(array)
      total = 0 
      array.each do |each_one|
          total += each_one.time_unit_minutes
      end
      total
    end


   end
end