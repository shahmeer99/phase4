module Contexts
  module JobContexts
      
    def create_jobs
      @cleaner = FactoryBot.create(:job)
  	  @cashier = FactoryBot.create(:job, name: "Cashier", description: "Works As Cashier", active: false)
  	end

  	def remove_jobs
  	  @cleaner.destroy
  	  @cashier.destroy
  	end
  
  end
end