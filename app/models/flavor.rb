class Flavor < ApplicationRecord
    # Callbacks
    before_delete :make_inactive #change delete method in controller
    
    #relationships
    has_many :store_flavors
    has_many :store_flavors
    has_many :stores, through: :store_flavors
    
    # Validations
    # make sure required fields are present
    validates_presence_of :name
    
    # Scopes
    scope :active,          -> { where(active: true) }
    scope :inactive,        -> { where(active: false) }
    scope :alphabetical,    -> { order('name') }
    
    # Callback code
    # -----------------------------
    private
    # can never be deleted, only made inactive
    def make_inactive
        self.active = false
    end
end
