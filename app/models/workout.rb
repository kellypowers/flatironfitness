class Workout < ActiveRecord::Base
    # extend Slugifiable::ClassMethods
    # include Slugifiable::InstanceMethods
    belongs_to :user
    has_many :goals, through: :workout_goals      
    
    
end