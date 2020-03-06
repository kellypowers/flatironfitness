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
  
    def total_minutes_towards_goal(array_workouts)
      total = 0 
      array_workouts.each do |each|
          total += each.time_unit_minutes
      end
      total
  end

  #right now these two methods are in the goal model. if i need to use elsewhere i might want to put them here...
  # def time_left(current_goal, total_workout_minutes_towards_goal)
  #   time_left = 0
  #   if current_goal.time_unit_minutes > total_workout_minutes_towards_goal
  #       time_left = current_goal.time_unit_minutes - total_workout_minutes_towards_goal
  #   end
  #   "You have #{time_left} minutes of #{current_goal.category} left to go!"
  # end

  # def workout_progress(total_minutes, goal)
  #   goal_minutes = goal.time_unit_minutes
  #   amount_completed = nil
  #   if goal_minutes > total_minutes 
  #       amount_completed = goal_minutes / total_minutes * 100 
  #       if total_minutes = 0 
  #           "Get started on meeting your goal of #{goal_minutes} minutes of #{goal.category}!"
  #       end
  #       if amount_completed < 50 
  #           "Keep it up! you are #{amount_completed}% of your way to your goal!"
  #       else
  #           "You are almost there! You are #{amount_completed} of your way to your goal!"
  #       end
  #   else
  #       "You have reached your goal! Congrats!"
  #   end
  # end


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