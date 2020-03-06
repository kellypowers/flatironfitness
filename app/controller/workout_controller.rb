require 'pry'
require 'rack-flash'
class WorkoutController < ApplicationController

    get '/workouts' do 
        @user = User.find(session[:user_id])
        #binding.pry
        @workouts = Workout.all
        erb :'/workouts/index'
    end

    get '/workouts/new' do 
        @user = User.find_by_id(params[:id])
        #@workouts = @user.workouts
        #@workouts = Workout.all
        erb :'/workouts/new'
    end


    get '/workouts/:id' do 
        @user = User.find(session[:user_id])
        @workout = Workout.find_by_id(params[:id])
        erb :'/workouts/show'
    end

    get '/workouts/:id/edit' do 
        @user = User.find(session[:user_id])
        @workouts = @user.workouts
        @workout = Workout.find_by_id(params[:id])
        #@workout = @user.workouts.find_by_id(params[:id])
        erb :'workouts/edit'
    end

    post '/workouts' do 
        @user = User.find(session[:user_id])
        @workout = Workout.create(params["workout"])
        valid_goals = Goal.valid_date_and_category(@workout.category)
        #finds goals that apply to the workout and adds ids of workout and goal to workout_goal table
        valid_goals.each do |goal|
            if @workout.is_in_current_goal_date?(goal.start_date, goal.end_date) && @workout.is_in_current_goal_category?(goal.category)
                WorkoutGoal.create(workout_id: @workout.id, goal_id: goal.id)
            end
        end
        #puts params
        @workout.user_id = @user.id
        @workout.save
        #binding.pry
        erb :'/workouts/index'
    end

    patch "/workouts/:id" do 
        @workout = Workout.find(params[:id])
        @user = User.find(session[:user_id])
        @workout.update(params["workout"])
        @workout.save
        redirect to "/workouts/#{@workout.id}"
    end


    delete "workouts/:id" do 
        Workout.destroy(params[:id])
        redirect to "/workouts"
    end
end
