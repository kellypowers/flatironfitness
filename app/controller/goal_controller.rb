class GoalController < ApplicationController

    get '/workouts' do 
        @user = User.find(session[:user_id])
        erb :'/goals/index'
    end

    get '/goals/new' do 
        @user = User.find_by_id(params[:id])
        erb :'/goals/new'
    end

    get '/goals/:id' do 
        @user = User.find(session[:user_id])
        @goal = Goal.find_by_id(params[:id])
        erb :'/goals/show'
    end

    get '/goals/index' do 
        @user = User.find(session[:user_id])
        erb :'/goals/index'
    end

    post '/goals' do 
        @user = User.find(session[:user_id])
        @goal = Goal.create(params["goal"])
        @goal.user_id = @user.id 
        @workouts_in_goal = Workout.all.all_in_goal(@goal.category, @goal.start_date, @goal.end_date)
        #this goes back to add any already made workouts to goal if applicable
        @workouts_in_goal.each do |workout|
            if !@goal.already_present?(@goal.id, workout.id)
                WorkoutGoals.create(workout_id: workout.id, goal_id: @goal.id)
            end
        end
        @goal.save
        redirect to '/users/home'
    end


    patch "/goals/:id" do 
        @goal = Goal.find(params[:id])
        @user = User.find(session[:user_id])
        @goal.update(params["goal"])
        @goal.save
        redirect to "/goal/#{@goal.id}"
    end


    delete "goals/:id" do 
        Goal.destroy(params[:id])
        redirect to "/goals"
    end
end


end