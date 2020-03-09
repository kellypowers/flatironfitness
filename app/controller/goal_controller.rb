class GoalController < ApplicationController

    get '/goals' do 
        @user = User.find(session[:user_id])
        erb :'/goals/index'
    end

    get '/goals/new' do 
        @user = User.find_by_id(params[:id])
        erb :'/goals/new'
    end

    get '/goals/:id' do 
        validate_goal("show")
        # @user = User.find(session[:user_id])
        # @goal = Goal.find_by_id(params[:id])
        #   if @goal.user_id == @user.id 
        #       erb :"/goals/show"
        #   else
        #     flash[:message] = "You can only view/edit your own goals."
        #     redirect "/goals"
        #   end
    end

    get '/goals/:id/edit' do 
        validate_goal("edit")
        # @user = User.find(session[:user_id])
        # @goal = Goal.find_by_id(params[:id])
        #   if @goal.user_id == @user.id 
        #       erb :"/goals/edit"
        #   else
        #     flash[:message] = "You can only view/edit your own goals."
        #     redirect "/goals"
        #   end
    end

    post '/goals' do 
        @user = User.find(session[:user_id])
        @goal = Goal.create(params["goal"])
        @goal.user_id = @user.id 
        @workouts_in_goal = Workout.all.all_in_goal(@goal.category, @goal.start_date, @goal.end_date)
        #this goes back to add any already made workouts to goal if applicable and if not already present.
        @workouts_in_goal.each do |workout|
            if !@goal.already_present?(@goal.id, workout.id)
                WorkoutGoal.create(workout_id: workout.id, goal_id: @goal.id)
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
        redirect to "/goals/#{@goal.id}"
    end


    delete "/goals/:id" do 
        Goal.destroy(params[:id])
        redirect to "/goals/index"
    end
end


