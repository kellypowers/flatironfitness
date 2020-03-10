class WorkoutGoal < ActiveRecord::Base
    belongs_to :goal
    belongs_to :workout
    
     #checks if the workoutid and goalid are already paired in workout_goals to prevent them being added twice
    def already_present?(workoutid, goalid)
        WorkoutGoal.all.each do |workout_goal_ids|
            if workout_goal_ids.workout_id == workoutid && workout_goal_ids.goal_id == goalid 
                return true
            end
        end
        false
    end
    
end