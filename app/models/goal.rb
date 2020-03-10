class Goal < ActiveRecord::Base
    #include DateAndTimeMethods
    has_many :workouts, through: :workout_goals
    belongs_to :user

    #want these four methods in a module to go to both Goal and Workout
        #puts date in format Month, DD, YYY
        def date_printed(dates)
            date = dates.to_s
            item = Date.parse(date)
            "#{Date::MONTHNAMES[item.month]} #{item.day}, #{item.year}"
        end

        #puts the date in format to be saved in the calendar when editing workout/goal
        def date_format_for_form_value(date)
            d = Date.parse(date.to_s)
            d.strftime("%Y-%m-%d")
        end

        #converts all time units to minutes to calculate progress
        def time_unit_minutes
            time = nil
            if self.time != 0
                if self.time_units == "minute(s)"
                    time = self.time 
                else
                    time = self.time * 60
                end
            else
                time = self.time
            end
            time
        end

        #are these ids already present in workoutgoal
        def already_present?(workoutid, goalid)
            WorkoutGoal.all.each do |workout_goal_ids|
                if workout_goal_ids.workout_id == workoutid && workout_goal_ids.goal_id == goalid 
                    return true
                end
            end
            false
        end
    

    #checks that the goal is current
    def is_current?
        start_time = Date.parse(self.start_date.to_s)
        end_time = Date.parse(self.end_date.to_s)
        date_string = Date.parse(Time.now.to_s)
        if date_string.between?(start_time, end_time)
            true
        else
            false
        end
    end

    #selects current goals
    def self.select_current
        current_goals =[]
        self.all.each do |each_goal|
            if each_goal.is_current?
                current_goals << each_goal
            end
        end
        current_goals
    end

    #verifies the date is current and category matches the workout, and the user ids match
    def self.valid_date_and_category(category, user)
        valid_date_and_cat = []
        self.select_current.each do |each_current_goal|
            if user.id == each_current_goal.user_id
                if each_current_goal.category == category 
                    valid_date_and_cat << each_current_goal
                end
            end
        end
        valid_date_and_cat 
    end

    #will show if there is more time needed to complete goal and how much, or says if goal has not been started or has been completed
    def time_left(current_goal, total_workout_minutes_towards_goal)
        time_left = nil
        if total_workout_minutes_towards_goal != 0 
            if current_goal.time_unit_minutes > total_workout_minutes_towards_goal
                time_left = current_goal.time_unit_minutes - total_workout_minutes_towards_goal
                "You have #{time_left} minutes of #{current_goal.category} left to go!"
            elsif current_goal.time_unit_minutes < total_workout_minutes_towards_goal
                "Zero minutes left to go! You did it!"
            end
        else 
            "You have #{current_goal.time} #{current_goal.time_units} of #{current_goal.category} left to go!" 
        end
    end

    #gives progress of the workouts towards a goal, how much left to complete of goal in percent
    def workout_progress(total_minutes, goal)
        goal_minutes = goal.time_unit_minutes
        amount_completed = nil
        if total_minutes != 0 
            if goal_minutes > total_minutes 
                amount_completed = (total_minutes.to_f / goal_minutes.to_f * 100).to_i 
                if amount_completed < 50 
                    "Keep it up! you are #{amount_completed}% of your way to your goal!"
                else
                    "You are almost there! You have completed #{amount_completed}% of your goal!"
                end
            else
                "You have reached your goal! Congrats!"
            end
        else 
            "Get started on meeting your goal of #{goal_minutes} minutes of #{goal.category}!"
        end
    end

    #in the goal index page goes back and states whether a goal was completed or not, if not then how much was completed.
    def completed_goal_status(total_minutes, goal)
        goal_minutes = goal.time_unit_minutes 
        amount_completed = nil 
        if total_minutes != 0 
            if goal_minutes > total_minutes
                amount_completed = (total_minutes.to_f / goal_minutes.to_f * 100).to_i 
                "You completed #{amount_completed}% of this goal."
            else
                "You completed this goal!"
            end
        else
            "You did not complete any of this goal."
        end
    end

end