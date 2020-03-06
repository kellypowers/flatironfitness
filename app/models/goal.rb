class Goal < ActiveRecord::Base
    # extend Slugifiable::ClassMethods
    # include Slugifiable::InstanceMethods
    has_many :workouts, through: :workout_goals
    belongs_to :user

    def date_printed(date)
        item = Date.parse(date.to_s)
        "#{Date::MONTHNAMES[item.month]} #{item.day}, #{item.year}"
    end

    def is_current?
        start_time = Date.parse(self.start_date.to_s)
        end_time = Date.parse(self.end_date.to_s)
        date_string = Date.parse(Time.now)
        if date_string.between?(start_time, end_time)
            true
        else
            false
        end
    end

    def self.select_current
        current_goals =[]
        self.all.each do |each_goal|
            if each_goal.is_current?
                current_goals << each_goal
            end
        end
        current_goals
    end

    

    def self.valid_date_and_category(category)
        valid_date_and_cat = []
        self.select_current.each do |each_current_goal|
            if each_current_goal.category == category 
                valid_cat << each_current_goal
            end
        end
        valid_date_and_cat 
    end
                



    # def is_current?(date)
    #     start_time = Date.parse(self.start_date.to_s)
    #     end_time = Date.parse(self.end_date.to_s)
    #     date_string = Date.parse(date.to_s)
    #     if date_string.between?(start_time, end_time)
    #         true
    #     else
    #         false
    #     end
    # end

    def time_unit_minutes
        if self.time_units == "minutes"
            self.time 
        else
            self.time / 60 
        end
    end

    #will ahve to do if workout is in goal date range first
    #have to incorporate ALL workouts that are valid
    def goal_progress(current_goal, total_workout_minutes_towards_goal)
        time_left = 0
        if current_goal.time_unit_minutes > total_workout_minutes_towards_goal
            time_left = current_goal.time_unit_minutes - total_workout_minutes_towards_goal
        end
        "You have #{time_left} minutes of #{current_goal.category} left to go!"
    end

    def already_present?(workoutid, goalid)
        WorkoutGoal.all.each do |workout_goal_ids|
            if workout_goal_ids.workout_id == workoutid && workout_goal_ids.goal_id == goalid 
                return true
            end
        end
        false
    end
    
end