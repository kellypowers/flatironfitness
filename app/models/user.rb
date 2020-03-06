class User < ActiveRecord::Base
    has_secure_password 
    has_many :workouts
    has_many :goals
    validates_presence_of :name, :email, :password
    validates_uniqueness_of :email

 

  end