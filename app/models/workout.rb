class Workout < ActiveRecord::Base
    belongs_to :user
    has_many :goals, through: :workout_goals
    
    #these two methods are in both goal and user.. but them in app controller?
    # def date_printed(dates)
    #     date = self.date.to_s
    #     item = Date.parse(date)
    #     "#{Date::MONTHNAMES[item.month]} #{item.day}, #{item.year}"
    # end

    # def date_format_for_form_value(date)
    #     d = Date.parse(date.to_s)
    #     d.strftime("%Y-%m-%d")
    # end



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

    def is_in_current_goal_category?(category)
        if self.category == category 
            true
        else
            false
        end
    end

    # def time_unit_minutes
    #     time = nil
    #     if self.time != 0
    #         if self.time_units == "minute(s)"
    #             time = self.time 
    #         else
    #             time = self.time * 60
    #         end
    #     else
    #         time = self.time
    #     end
    #     time
    # end

    def self.all_in_goal(goal_category, start_date, end_date)
        array_of_workouts_in_goal = []
        self.all.each do |each_workout|
            if each_workout.is_in_current_goal_category?(goal_category) && each_workout.is_in_current_goal_date?(start_date, end_date)
                array_of_workouts_in_goal << each_workout
            end
        end
        array_of_workouts_in_goal
    end

    #need to check that it is in category & time frame
    def total_minutes_towards_goal(array)
        total = 0 
        array.each do |each_one|
            total += each_one.time_unit_minutes
        end
        total
    end

            



end