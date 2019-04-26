require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Test relationships
  should belong_to(:employee)
  
  #validations
  should allow_value("msahmad@andrew.cmu.edu").for(:email)
  should allow_value("mshahmeer99@gmail.com").for(:email)
  should allow_value("shah_meer@hotmail.com").for(:email)
  
  should_not allow_value("bad").for(:email)
  should_not allow_value(nil).for(:email)
  should_not allow_value("1234").for(:email)
  should_not allow_value("sadfdgd6t7a31").for(:email)
  should_not allow_value("com.msahmad.@.c").for(:email)
  
  
  #create contexts
  context "user contexts" do
  
    #create factories
    setup do 
      @test = FactoryBot.create(:employee)
      @test_user = FactoryBot.create(:user, employee: @test)
    end
    
    teardown do
      @test.destroy
    end
    
    #test scopes and methods 
    should "Assure that user can only be added to an active employee" do
      @employee = FactoryBot.build(:employee)
      @user = FactoryBot.build(:user, email:"user1@cmu.edu", employee: @employee)
      assert @user.employee_is_active_in_system
      assert @test_user.valid?
      @bad = FactoryBot.build(:user, email:"bad@cmu.edu", employee: @inactive)
      assert !@bad.valid?
      @bad.destroy
    end
    
    should "Show that user is automatically deleted when employee is deleted" do
      @test.destroy
      assert @test.destroyed?
      assert @test_user.destroyed?
    end
    
    should "make sure user_role function works" do
      @employee = FactoryBot.build(:employee, first_name: "Shahmeer", last_name: "Ahmad", ssn: "123-67-8236", phone: "949-675-2317", role: "manager")
      @user = FactoryBot.build(:user, email:"msahmad@cmu.edu", employee: @employee) 
      assert_equal "manager", @user.user_role
      @user.destroy
      @employee.destroy
    end
  end
end
