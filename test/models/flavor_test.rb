require 'test_helper'

class FlavorTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:store_flavors)
  should have_many(:stores).through(:store_flavors)
  
  #validations
  should validate_presence_of(:name)
  
  #create contexts
  context "flavor contexts" do
  
    #create factories
    setup do 
      create_flavors
    end
    
    teardown do
      remove_flavors
    end
    
    should "have one active flavor" do
      assert_equal 1, Flavor.active.size
      assert_equal ["Rocky"], Flavor.active.map{|flavor| flavor.name}
    end
    
    should "have one inactive flavor" do
      assert_equal 1, Flavor.inactive.size
      assert_equal ["Coffee"], Flavor.inactive.map{|flavor| flavor.name}
    end
    
    should "make sure flavors are never destroyed, only made inactive" do
      @rocky.destroy
      assert_equal 2, Flavor.inactive.size
      assert_equal ["Coffee", "Rocky"], Flavor.alphabetical.map{|flavor| flavor.name}
    end

    should "have flavors in alphabetical order" do
      assert_equal 2, Flavor.alphabetical.size
      assert_equal ["Coffee", "Rocky"], Flavor.alphabetical.map{|flavor| flavor.name}
    end
    

  
  end
end
