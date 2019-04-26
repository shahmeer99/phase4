module Contexts
  module FlavorContexts
      
    def create_flavors
      @rocky = FactoryBot.create(:flavor)
  	  @coffee = FactoryBot.create(:flavor, name: "Coffee", active: false)
  	end

  	def remove_flavors
  	  @rocky.destroy
  	  @coffee.destroy
  	end
  
  end
end