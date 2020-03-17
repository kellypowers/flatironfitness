class GoalController < ApplicationController

    get '/goals' do 
        @user = current_user
        erb :'/goals/index'
    end

    get '/goals/new' do     
        @user = current_user
        erb :'/goals/new'
    end

    get '/goals/:id' do 
        @goal = Goal.find(params[:id])
        #binding.pry
        if ensure_auth(@goal)
            erb :'/goals/show'
        else
            redirect "/goals"
        end
    end
    

    get '/goals/:id/edit' do 
        @goal = Goal.find(params[:id])
        if ensure_auth(@goal)
            erb :'/goals/edit'
        else
            redirect "/goals/#{@goal.id}"
        end
    end

    post '/goals' do 
        #check that time is not a string.
        if !params["goal"]["time"].match(/^(\d*\.)?\d+$/)
            flash[:message] = "Please type a number in for Time"
            erb :'/goals/new'
        else
            @goal = Goal.new(params["goal"])
            @goal.user_id = current_user.id 
            #binding.pry
            #this goes back to add any already made workouts to goal if applicable and if not already present.
            @goal.set_workouts
            if @goal.save
                redirect to '/users/home'
            end
        end
        redirect to "/goals/new"  
    end
            
        


    patch "/goals/:id" do 
        @goal = Goal.find(params[:id])
        if ensure_auth(@goal)
                if !params["goal"]["time"].match(/^(\d*\.)?\d+$/)
                    flash[:message] = "Please type a number in for Time"
                    redirect to "/goals/#{@goal.id}/edit"
                else
                    @goal.update(params["goal"])
                    @goal.save
                    redirect to "/goals/#{@goal.id}"
                end
            else 
                redirect to "/goals/#{@goal.id}/edit"
            end
        end


    delete "/goals/:id" do 
        @goal = Goal.find(params[:id])
        if ensure_auth(@goal)
            Goal.destroy(params[:id])
            redirect to "/goals/index"
        else
            redirect "/goals#{@goal.id}"
        end
    end


end


