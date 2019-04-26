require 'test_helper'

class StoreFlavorTest < ActiveSupport::TestCase
  # TEST RELATIONSHIPS
  should belong_to(:flavor)
  should belong_to(:store)
  
  # TEST VALIDATIONS 
  should validate_presence_of :store_id 
  should validate_presence_of :flavor_id
  
end
