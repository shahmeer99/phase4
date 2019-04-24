require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:shift)
  should belong_to(:job)
end
