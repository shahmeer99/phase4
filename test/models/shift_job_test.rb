require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase
  # TEST RELATIONSHIPS
  should belong_to(:shift)
  should belong_to(:job)
  
  # TEST VALIDATIONS 
  should validate_presence_of :shift_id 
  should validate_presence_of :job_id
  
end
