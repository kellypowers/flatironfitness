require 'pry'
require 'rack-flash'

class WorkoutController < ApplicationController

    #gets index of all workouts for user, Read
    #can this be hijacked to view other users workouts?
    get '/workouts' do 
        @user = User.find(session[:user_id])
        @workouts = Workout.all
        #binding.pry
        erb :'/workouts/index'
    end

    #gets form to Create new workout
    get '/workouts/new' do 
        @user = User.find_by_id(params[:id])
        erb :'/workouts/new'
    end

    #shows individual workouts
    get '/workouts/:id' do 
       @workout = Workout.find_by_id(params[:id])
       if ensure_auth(@workout)
           erb :"workouts/show"
       else 
           redirect '/workouts'
       end
    end

    #edits individual workouts
    get '/workouts/:id/edit' do 
        #validate_workout("edit")
        @workout = Workout.find_by_id(params[:id])
        if ensure_auth(@workout)
            erb :"workouts/edit"
        else 
            redirect '/workouts'
        end
    end

    #post to create new workout
    post '/workouts' do 
        #check that time is a number not a string.
        if !params["workout"]["time"].match(/^(\d*\.)?\d+$/)
            flash[:message] = "Please type a number in for Time"
            erb :'/workouts/new'
        else
            @workout = Workout.create(params["workout"])
            valid_goals = Goal.valid_date_and_category(@workout.category, current_user)
            #finds goals that apply to the workout and adds ids of workout and goal to workout_goal table
            valid_goals.each do |goal|
                if @workout.is_in_current_goal_date?(goal.start_date, goal.end_date) && @workout.is_in_current_goal_category?(goal.category)
                    WorkoutGoal.create(workout_id: @workout.id, goal_id: goal.id)
                end
            end
            @workout.user_id = current_user.id
            @workout.save
        end
    redirect '/workouts'
    end

    patch "/workouts/:id" do 
        @workout = Workout.find(params[:id])
        if ensure_auth(@workout)

                if !params["workout"]["time"].match(/^(\d*\.)?\d+$/)
                    flash[:message] = "Please type in a valid number for amount of Time."
                    redirect to "/workouts/#{@workout.id}/edit"
                else
                    @workout.update(params["workout"])
                    #if workout category has changed, see if there is a goal with that category and date and add ids to workout_goal table
                    if params["workout"]["category"] != @workout.category 
                        valid_goals = Goal.valid_date_and_category(@workout.category, @user)
                        valid_goals.each do |goal|
                            if @workout.is_in_current_goal_date?(goal.start_date, goal.end_date) && @workout.is_in_current_goal_category?(goal.category)
                                WorkoutGoal.create(workout_id: @workout.id, goal_id: goal.id)
                            end
                        end
                    end
                    @workout.save
                end
        end
        redirect to "/workouts/#{@workout.id}"
    end

    # delete "/workouts/:id" do 

    #     Workout.destroy(params[:id])
    #     redirect to "/workouts"
    # end

    delete "/workouts/:id" do 
        @workout = Workout.find(params[:id])
        if ensure_auth(@workout)
            Workout.destroy(params[:id])
            session.clear
            redirect to "/workouts/index"
        else
            flash[:message] = "You do not have permission to delete that workout"
            redirect "/workouts/#{@workout.id}"
        end
    end

end
