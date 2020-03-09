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

  #these two validate made the edit button not work.. if can get to work, can implement.
  def validate_goal(string)
    @user = User.find(session[:user_id])
    @goal = Goal.find_by_id(params[:id])
      if @goal.user_id == @user.id 
          erb :"/goals/#{string}"
      else
        flash[:message] = "You can only view/edit your own goals."
        redirect "/goals"
      end
  end

  def validate_workout(string)
    @user = User.find(session[:user_id])
    @workout = Workout.find_by_id(params[:id])
      if @workout.user_id == @user.id 
        erb :"/workouts/#{string}"
      else
        flash[:message] = "You can only view/edit your own workouts."
        redirect '/workouts'
      end
  end

   end
end