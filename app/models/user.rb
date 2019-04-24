class User < ApplicationRecord
  #when created, must be connected to an employee who is active in the system
  before_create 
  # Relationships
  belongs_to :employee
  
  has_secure_password
  
  #validations
  validates_presence_of :email, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates_presence_of :password_digest #, length: {minimum: 5}
end