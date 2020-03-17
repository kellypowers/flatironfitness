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
    end

    get '/goals/:id/edit' do 
        validate_goal("edit")
    end

    post '/goals' do 
        @user = User.find(session[:user_id])
        @goal = Goal.find(params[:id])
        #check that time is not a string.
        #binding.pry
        if ensure_auth(@goal) 
            if !params["goal"]["time"].match(/^(\d*\.)?\d+$/)
                flash[:message] = "Please type a number in for Time"
                erb :'/goals/new'
            else
                @goal = Goal.create(params["goal"])
                @goal.user_id = @user.id 
                @workouts_in_goal = Workout.all.all_in_goal(@goal.category, @goal.start_date, @goal.end_date, @user)
                #this goes back to add any already made workouts to goal if applicable and if not already present.
                @workouts_in_goal.each do |workout|
                    if !@goal.already_present?(@goal.id, workout.id)
                        WorkoutGoal.create(workout_id: workout.id, goal_id: @goal.id)
                    end
                end
                @goal.save
                redirect to '/users/home'
            end
        else
            redirect to "/goals/new"  
        end
    end

    patch "/goals/:id" do 
        @goal = Goal.find(params[:id])
        @user = User.find(session[:user_id])
        if @goal.user != current_user 
            flash[:message] = "You can only view/edit your own goals"
                redirect '/goals'
        else
            if !params["goal"]["time"].match(/^(\d*\.)?\d+$/)
                flash[:message] = "Please type a number in for Time"
                redirect to "/goals/#{@goal.id}/edit"
            else
                @goal.update(params["goal"])
                @goal.save
                redirect to "/goals/#{@goal.id}"
            end
        end
    end

    delete "/goals/:id" do 
        @goal = Goal.find(params[:id])
        if @goal.user != current_user 
            flash[:message] = "You can only delete your own goals"
            redirect '/goals'
        else
            Goal.destroy(params[:id])
            redirect to "/goals/index"
        end
    end

end


