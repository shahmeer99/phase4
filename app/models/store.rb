class Store < ApplicationRecord
# Callbacks
  before_save :reformat_phone
  #before_destroy :cannot_delete
  
  
  # Relationships
  has_many :assignments
  has_many :employees, through: :assignments  
  has_many :store_flavors
  has_many :flavors, through: :store_flavors
  has_many :shifts, through: :assignments
  
  # Validations
  # make sure required fields are present
  validates_presence_of :name, :street, :zip
  # if state is given, must be one of the choices given (no hacking this field)
  validates_inclusion_of :state, :in => %w[PA OH WV], message: "is not an option"
  # if zip included, it must be 5 digits only
  validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
  # phone can have dashes, spaces, dots and parens, but must be 10 digits
  validates_format_of :phone, with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only"
  # make sure stores have unique names
  validates_uniqueness_of :name
  
  # Scopes
  scope :alphabetical, -> { order('name') }
  scope :active,       -> { where(active: true) }
  scope :inactive,     -> { where(active: false) }
  
  
  # Misc Constants
  STATES_LIST = [['Ohio', 'OH'],['Pennsylvania', 'PA'],['West Virginia', 'WV']]
  
  #before_destroy :make_inactive, :cancel_destroy
  before_destroy :destroy_stop
  after_rollback :make_inactive
  
  
  def destroy_stop
    self.errors.add(:base, 'cannot delete a store')
    throw(:abort)
  end

  def make_inactive
  	 self.update_attribute(:active, false)
  end
  
  private
  # We need to strip non-digits before saving to db
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end
  

end
