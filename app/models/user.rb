class User < ActiveRecord::Base
    extend Slugifiable::ClassMethods
    include Slugifiable::InstanceMethods
    has_secure_password 
    has_many :workouts
    has_many :goals
    validates_presence_of :name, :email, :password
    validates_uniqueness_of :email


  end