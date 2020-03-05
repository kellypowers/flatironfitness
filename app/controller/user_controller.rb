require 'pry'
require 'rack-flash'
# Validate uniqueness of user login attribute (username or email).
# Validate user input so bad data cannot be persisted to the database.
#  Display validation failures to user with error messages.
# Ensure that users can edit and delete only their own resources - not resources created by other users.
class UserController < ApplicationController
    use Rack::Flash 

    get '/registrations/signup' do
        if logged_in?
            redirect to "/users/home"
        else
            erb :'/registrations/signup'
        end
    end
 
    post '/registrations' do
            @user = User.new(params[:user])
            if params[:user][:password] == params[:password2]
                @user.save
                session[:user_id] = @user.id
                redirect "/users/home"
            else
                flash[:message] = "Passwords don't match"
                redirect "/registrations/signup"
            # end
        end
    end

    get '/sessions/login' do
        if logged_in? 
            redirect to "/users/home"
        elsif @user = User.find_by(:email => params[:email])
            if user && user.authenticate(params[:password])
                session[:user_id] = user.id 
                redirect "/users/home"
            end
        else
            erb :"/sessions/login"
        end
    end

    post '/sessions' do
        @user = User.find_by(email: params["user"]["email"])
        if @user && @user.authenticate(params["user"]["password"])
            session[:user_id] = @user.id
            redirect '/users/home'
        else
            flash[:message] = "Invalid username/password. Please sign up."
            redirect '/registrations/signup'
        end
    end

    get '/sessions/logout' do
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