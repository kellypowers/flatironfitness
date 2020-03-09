require "./config/environment"
require "./app/models/user"

class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "fitnessprogress"
    set :views, Proc.new { File.join(root, "../views/") }
    set :public_folder, 'public'
    set :show_exceptions, false
  end

  get '/' do
    redirect to '/users/home'
  end

  error do 
    redirect '/'
  end


  def current_user 
    @current_user ||= User.find_by_id(session[:user_id])
  end

  helpers do
    def logged_in?
      !!current_user
    end
    
  #   def total_minutes_towards_goal(array)
  #     total = 0 
  #     array.each do |each_one|
  #         total += each_one.time_unit_minutes
  #     end
  #     total
  #   end


  #   def date_printed(dates)
  #     date = self.date.to_s
  #     item = Date.parse(date)
  #     "#{Date::MONTHNAMES[item.month]} #{item.day}, #{item.year}"
  #   end

  #   def date_format_for_form_value(date)
  #       d = Date.parse(date.to_s)
  #       d.strftime("%Y-%m-%d")
  #   end


  #   def time_unit_minutes
  #   time = nil
  #     if self.time != 0
  #       if self.time_units == "minute(s)"
  #         time = self.time 
  #       else
  #         time = self.time * 60
  #           end
  #     else
  #       time = self.time
  #     end
  #     time
  #   end



   end
end