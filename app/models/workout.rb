class Workout < ActiveRecord::Base
    belongs_to :user
   # has_many :goals, through: :workout_goals      
    
    
    
    end