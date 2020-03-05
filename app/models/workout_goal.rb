class WorkoutGoal < ActiveRecord::Base
    belongs_to :goal
    belongs_to :workout
    
    
    
end