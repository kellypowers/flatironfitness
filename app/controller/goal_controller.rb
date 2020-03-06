class GoalController < ApplicationController

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
        @goal.save
        redirect to '/users/home'
    end

    


end