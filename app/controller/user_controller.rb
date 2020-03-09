require 'pry'
require 'rack-flash'

class UserController < ApplicationController
    use Rack::Flash           
    
    get '/users/home' do
        if logged_in?
            # binding.pry
            @user = User.find(session[:user_id])
            erb :'/users/home'
        else
            erb :'/users/login'
        end
    end

    get '/signup' do
        if logged_in? 
            @user = User.find(session[:user_id])
            redirect "/users/#{@user.id}"
        else
            erb :'/users/signup'
        end
    end
 
    post '/signup' do
        existing_users = User.all.map{|each| each.email}
        if existing_users.include?(params[:user][:email])
            flash[:message] = "That email is already taken." 
            redirect '/signup'
        else
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
    end

    get '/login' do
        @user = User.find_by_id(params[:id])
        # @user = User.new(params[:user])
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

    get '/users/:id/home' do 
        redirect '/users/home'
    end

    get '/users/:id' do 
       validate_user("home")
    end

    get '/users/:id/account' do
        validate_user("account")
    end

    get '/users/:id/edit' do 
        validate_user("edit")
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
            end
            if params["name"] != @user.name 
                @user.name = params[:name]
                @user.save
            end
            flash[:message] = "Account info successfully edited"
            redirect "/users/#{@user.id}/account"
        end
    end

    get '/logout' do
        session.clear
        redirect '/'
    end

    delete "/users/:id" do 
        @user = User.find(session[:user_id])
        if @user.id == params[:id].to_s
            User.destroy(params[:id])
            session.clear
            redirect to "/"
        else
            flash[:message] = "You do not have permission to delete that account"
            redirect "/"
        end
    end
end