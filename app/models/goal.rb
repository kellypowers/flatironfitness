class Goal < ActiveRecord::Base
    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
    has_many :workouts, through: :workout_goals
    belongs_to :user
    

end