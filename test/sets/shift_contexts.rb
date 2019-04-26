module Contexts
  module ShiftContexts
      
    def create_shifts
      @shift_now = FactoryBot.create(:shift, assignment: @assign_cindy)
  	  @shift_later = FactoryBot.create(:shift, assignment: @assign_cindy, date: Date.current + 5, start_time: Date.current + 3.hours)
  	end

  	def remove_shifts
  	  @shift_now.destroy
  	  @shift_later.destroy
  	end
  
  end
end