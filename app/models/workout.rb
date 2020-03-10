# require 'sinatra/base'

class Workout < ActiveRecord::Base
    include DateAndTimeMethods
    belongs_to :user
    has_many :goals, through: :workout_goals

    def is_in_current_goal_date?(start_date, end_date)
        start_time = Date.parse(start_date.to_s)
        end_time = Date.parse(end_date.to_s)
        date_string = Date.parse(self.date.to_s)
        if date_string.between?(start_time, end_time)
            true
        else
            false
        end
    end

    #does the workout apply to the goal category?
    def is_in_current_goal_category?(category)
        if self.category == category 
            true
        else
            false
        end
    end

    #finds all workouts in goal category and date frame. making sure only the user's workouts are selected.
    def self.all_in_goal(goal_category, start_date, end_date, user)
        array_of_workouts_in_goal = []
        self.all.each do |each_workout|
            if user.id == each_workout.user_id
                if each_workout.is_in_current_goal_category?(goal_category) && each_workout.is_in_current_goal_date?(start_date, end_date)
                    array_of_workouts_in_goal << each_workout
                end
            end
        end
        array_of_workouts_in_goal
    end

    #calculates the total minutes towards a goal. will take in the all_in_goal array.
    def total_minutes_towards_goal(array)
        total = 0 
        array.each do |each_one|
            total += each_one.time_unit_minutes
        end
        total
    end

end