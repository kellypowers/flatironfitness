require 'pry'
require 'rack-flash'
# Validate uniqueness of user login attribute (username or email).
# Validate user input so bad data cannot be persisted to the database.
#  Display validation failures to user with error messages.
# Ensure that users can edit and delete only their own resources - not resources created by other users.
class UserController < ApplicationController
    use Rack::Flash 
                
    get '/users/home' do
        if logged_in?
            @user = User.find(session[:user_id])
            @workouts = @user.workouts
            erb :'users/home'
        else
            erb :'/users/login'
        end
    end

    get '/signup' do
        @user = User.new(params[:user])
        if logged_in? 
            redirect "/users/#{@user.id}"
        else
            erb :'/users/signup'
        end
    end
 
    #add a message if email is taken?
    post '/signup' do
        @user = User.new(params[:user])
        if params[:user][:password] == params[:password2]
            @user.save
            session[:user_id] = @user.id
            redirect "/users/#{@user.id}"
        else
            flash[:message] = "Passwords don't match"
            redirect "/signup"
        
        end
    end

    get '/login' do
        @user = User.new(params[:user])
        if logged_in? 
            redirect "/users/#{@current_user.id}"
        else
            erb :'users/login'
        end
    end

    post '/login' do
        @user = User.find_by(email: params["user"]["email"])
        if @user && @user.authenticate(params["user"]["password"])
            session[:user_id] = @user.id
            redirect "/users/#{@user.id}"
        else
            flash[:message] = "Invalid username/password. Please sign up."
            redirect '/signup'
        end
    end

    #this will be home page, if can figure out how to make slugs unique even if names are same.. use slug instead of id
    get '/users/:id' do 
        #binding.pry
        @user = User.find_by_id(params[:id])
        if logged_in?
            # @user = User.find_by_slug(params[:slug])
            #is this validation ok/needed?
            # if @user.id == params[:id]
                #should check for this in views
                #!@user.workouts.empty? ? (@workouts = @user.workouts) : (@workouts = nil)
                @workouts = @user.workouts 
                @goals = @user.goals
                erb :'/users/home'
            # else
            #     flash[:message] = "You don't have permissions for that profile."
            #     redirect "/users/#{current_user.id}"
            # end
        else
            redirect '/'
        end
    end

    get '/users/:id/account' do
        if logged_in?
            @user = User.find(session[:user_id])
            erb :'/users/account'
        else
            flash[:message] = "Please log in to access your account."
            redirect '/login'
        end
    end

    #should i put  [logged_in? if @user.id == params[:id] ] in a validation method in model to DRY?
    get '/users/:id/edit' do 
        if logged_in?
            @user = User.find_by_id(params[:id])
            erb :"users/edit"
        else 
            redirect to '/login'
        end
    end


    patch '/users/:id' do 
        @user = User.find(session[:user_id])
        if !@user.authenticate(params[:password])
            flash[:message] = "Please type in your current password to make changes"
            redirect to "/users/#{@user.id}/edit"
        else
            @user.password = params[:password]
            if !params["new_password"].empty? 
                if params["new_password"] == params["new_password_2"]
                    @user.password = params[:new_password]
                    @user.save
                else
                    flash[:message] = "New passwords do not match"
                    redirect "/users/#{@user.id}/edit"
                end
            end
            if params["email"] != @user.email 
                @user.email = params[:email]
                @user.save
                #do i want to prompt "do you want to change THIS to THAT" ?
            end
            if params["name"] != @user.name 
                @user.name = params[:name]
                @user.save
            end
            flash[:message] = "Account info successfully edited"
            redirect "/users/#{@user.id}/account"
        end
    end

    get '/users/logout' do
        session.clear
        redirect '/'
    end

    delete "/users/:id" do 
        @user = User.find(session[:user_id])
        User.destroy(params[:id])
        session.clear
        redirect to "/"
    end
end