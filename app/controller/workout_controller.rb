require 'pry'
require 'rack-flash'
class WorkoutController < ApplicationController

    get '/workouts' do 
        @user = User.find(session[:user_id])
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
        #puts params
        @workout.user_id = @user.id
        @workout.save
        #binding.pry
        erb :'/workouts/index'
    end

    # patch "/workouts/:id" do 
    #     @workout = Workout.find(params[:id])
    #     @user = User.find(session[:user_id])
    #     @user.update(params[:user])
    #     params["workout"].each do |key, value|
    #         binding.pry
    #         if value = ""
    #             @workout.send("#{key}") = null
    #         else
    #             @workout.send("#{key}") = value
    #         end
    #     end
    #     @workout.save
    #     @user.workouts << @workout
    #     #@workout.update(params[:workout])
    #     redirect to "/workouts/#{@workout.id}"
    #   end


    delete "workouts/:id" do 
        Workout.destroy(params[:id])
        redirect to "/workouts"
    end
end
