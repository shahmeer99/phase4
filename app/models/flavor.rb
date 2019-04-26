class Flavor < ApplicationRecord
  has_many :store_flavors
  has_many :stores, through: :store_flavors

  validates_presence_of :name

  scope :active,          -> { where(active: true) }
  scope :inactive,        -> { where(active: false) }
  scope :alphabetical,    -> { order('name') }
  
  before_destroy :destroy_stop
  after_rollback :make_inactive
  
  def destroy_stop
    self.errors.add(:base, 'Cannot Delete')
    throw(:abort)
  end
  
  def make_inactive
  	self.active = false
  	self.save
  end
  
end

