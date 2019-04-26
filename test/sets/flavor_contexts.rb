module Contexts
  module FlavorContexts
      
    def create_flavors
      @vanilla = FactoryBot.create(:flavor)
  	  @chocolate = FactoryBot.create(:flavor, name: "Chocolate", active: false)
  	end

  	def remove_flavors
  	  @vanilla.destroy
  	  @chocolate.destroy
  	end
  
  end
end