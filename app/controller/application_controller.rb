require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views" #dont need this bc line 10
    enable :sessions
    set :session_secret, "fitnessprogress"
    set :views, Proc.new { File.join(root, "../views/") }
    set :public_folder, 'public'
    #set :show_exceptions, false #this is for line 19, if user tries to view workout/goal that has been deleted, rather than get an error page it will redirect home
  end

  get '/' do
    redirect to '/users/home'
  end

  # error do 
  #   redirect '/'
  # end

  def current_user 
    #@current_user || current_user = User.find_by_id(session[:user_id])
    @current_user ||= User.find_by_id(session[:user_id])
    #@current_user == User.find(session[:user_id])
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

        #validate user
    def validate_user(string)
      @user = User.find(session[:user_id])
      if logged_in?
          if @user.id == params[:id].to_i
              erb :"/users/#{string}"
          else 
              flash[:message] = "You do not have permission to view that profile"
              redirect "/users/#{@user.id}/#{string}"
          end
      else 
          redirect to '/login'
      end
    end
  
    def ensure_auth(string)
        if string.user == current_user 
          return true
        else
          flash[:message] = "You can only view/edit your own data."
          return false
        end
    end
  end
end