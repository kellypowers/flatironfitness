require 'pry'
require 'rack-flash'
# Validate uniqueness of user login attribute (username or email).
# Validate user input so bad data cannot be persisted to the database.
#  Display validation failures to user with error messages.
# Ensure that users can edit and delete only their own resources - not resources created by other users.
class UserController < ApplicationController
    use Rack::Flash 
                
    get '/signup' do
        logged_in? ? (redirect to "/users/home") : (erb :'/users/signup')
    end
 
    #add a message if email is taken?
    post '/signup' do
        @user = User.new(params[:user])
        if params[:user][:password] == params[:password2]
            @user.save
            session[:user_id] = @user.id
            redirect "/users/:slug"
        else
            flash[:message] = "Passwords don't match"
            redirect "/signup"
        
        end
    end

    get '/login' do
        logged_in? ? (redirect '/users/:slug') : (erb :'users/login')
    end

    post '/login' do
        @user = User.find_by(email: params["user"]["email"])
        if @user && @user.authenticate(params["user"]["password"])
            session[:user_id] = @user.id
            redirect '/users/:slug'
        else
            flash[:message] = "Invalid username/password. Please sign up."
            redirect '/registrations/signup'
        end
    end

    #this will be home page
    get '/users/:slug' do 
        if logged_in?
            # @user = User.find_by_slug(params[:slug])
            @user = User.find_by_id(params[:id])
            #is this validation ok/needed?
            if @user.slug == params[:slug]
                #should check for this in views
                #!@user.workouts.empty? ? (@workouts = @user.workouts) : (@workouts = nil)
                @workouts = @user.workouts 
                @goals = @user.goals
                erb :'/users/home'
            else
                flash[:message] = "You don't have permissions for that profile."
                redirect :"/users/#{current_user.slug}"
            end
        else
            redirect '/'
        end
    end

    get '/users/:slug/account' do
        if logged_in?
            @user = User.find(session[:user_id])
            if @user.slug == params[:slug]
                erb :'/users/account'
            else
                flash[:message] = "You don't have permissions for that account."
                redirect :"/users/#{current_user.slug}/account"
            end
        else
            flash[:message] = "Please log in to access your account."
            erb :'/login'
        end
    end

    #should i put  if @user.slug == params[:slug] i a validation method in model?
    get '/users/:slug/edit' do 
        if logged_in?
            if @user.slug == params[:slug]
                erb :"users/edit"
            end
        else 
            redirect to '/login'
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