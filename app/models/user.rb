class User < ActiveRecord::Base
    # extend Slugifiable::ClassMethods
    # include Slugifiable::InstanceMethods
    has_secure_password 
    has_many :workouts
    has_many :goals
    validates_presence_of :name, :email, :password
    validates_uniqueness_of :email

    #if slug is taken, how can i edit to make ok?  right now use id, then go back and figure this out.


  end