require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:assignments)
  should have_many(:stores).through(:assignments)
  
  # Test basic validations
   should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:ssn)
  should validate_presence_of(:role)
  should validate_presence_of(:date_of_birth)
  
  # TESTING PHONE
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should allow_value(nil).for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  # tests for ssn
  should allow_value("123456789").for(:ssn)
  should_not allow_value("12345678").for(:ssn)
  should_not allow_value("1234567890").for(:ssn)
  should_not allow_value("bad").for(:ssn)
  should_not allow_value(nil).for(:ssn)
   # test date_of_birth
  should allow_value(17.years.ago.to_date).for(:date_of_birth)
  should allow_value(15.years.ago.to_date).for(:date_of_birth)
  should allow_value(14.years.ago.to_date).for(:date_of_birth)
  should_not allow_value(13.years.ago).for(:date_of_birth)
  should_not allow_value("bad").for(:date_of_birth)
  should_not allow_value(nil).for(:date_of_birth)
   # tests for role
  should allow_value("admin").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("employee").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("vp").for(:role)
  should_not allow_value(nil).for(:role)

  context "Creating a context for employees" do
    # create the objects I want with factories
    setup do 
      create_employees
    end
    
    # and provide a teardown method as well
    teardown do
      remove_employees
    end
  
    # test employees must have unique ssn
    should "force employees to have unique ssn" do
      ssn_copy = FactoryBot.build(:employee, first_name: "Madelene", last_name: "Edward", ssn: "084-35-9822")
      assert_equal false , ssn_copy.valid? 
    end
    
    #SCOPE younger_than_18
    should "show there are two employees under 18" do
      assert_equal 2, Employee.younger_than_18.size
      assert_equal ["Crawford", "Wilson"], Employee.younger_than_18.map{|e| e.last_name}.sort
    end
    
    #SCOPE younger_than_18
    should "show there are five employees over 18" do
      assert_equal 5, Employee.is_18_or_older.size
      assert_equal ["Ahmad", "Gruberman", "Heimann", "Janeway", "Sisko"], Employee.is_18_or_older.map{|e| e.last_name}.sort
    end
    
    #SCOPE 'active'
    should "shows that there are six active employees" do
      assert_equal 6, Employee.active.size
      assert_equal ["Ahmad", "Crawford", "Gruberman", "Heimann", "Janeway", "Sisko"], Employee.active.map{|e| e.last_name}.sort
    end
    
    #SCOPE 'inactive'
    should "shows that there is one inactive employee" do
      assert_equal 1, Employee.inactive.size
      assert_equal ["Wilson"], Employee.inactive.map{|e| e.last_name}.sort
    end
    
    #SCOPE 'regulars'
    should "shows that there are 3 regular employees: Ed, Cindy and Ralph" do
      assert_equal 3, Employee.regulars.size
      assert_equal ["Crawford","Gruberman","Wilson"], Employee.regulars.map{|e| e.last_name}.sort
    end
    
    #SCOPE 'managers'
    should "shows that there are 3 managers: Ben and Kathryn" do
      assert_equal 3, Employee.managers.size
      assert_equal ["Ahmad", "Janeway", "Sisko"], Employee.managers.map{|e| e.last_name}.sort
    end
    
    #SCOPE 'admins'
    should "shows that there is one admin: Alex" do
      assert_equal 1, Employee.admins.size
      assert_equal ["Heimann"], Employee.admins.map{|e| e.last_name}.sort
    end
    
    #METHOD 'name'
    should "shows name as last, first name" do
      assert_equal "Heimann, Alex", @alex.name
    end   
    
    #METHOD 'proper_name'
    should "shows proper name as first and last name" do
      assert_equal "Alex Heimann", @alex.proper_name
    end 
    
    #METHOD 'current_assignment'
    should "shows return employee's current assignment if it exists" do
      create_stores
      create_assignments
      assert_equal @assign_cindy, @cindy.current_assignment 
      assert_equal @promote_ben, @ben.current_assignment 
      @assign_cindy.update_attribute(:end_date, Date.current)
      @cindy.reload
      assert_nil @cindy.current_assignment
      assert_nil @alex.current_assignment
      remove_assignments
      remove_stores
    end
    
    # CALLBACK 'reformat_ssn'
    should "shows that Cindy's ssn is stripped of non-digits" do
      assert_equal "084359822", @cindy.ssn
    end
    
    # CALLBACK 'reformat_phone'
    should "shows that Ben's phone is stripped of non-digits" do
      assert_equal "4122682323", @ben.phone
    end
    
    should "show that an employee is only deleted if he works no shifts" do
      @cmu = FactoryBot.create(:store)
      @msa2 = FactoryBot.create(:employee, first_name: "m", last_name: "sa", ssn: "123-12-1234", date_of_birth: 19.years.ago.to_date)
      @assignment_msa = FactoryBot.create(:assignment, employee: @msa2, store: @cmu, start_date: 6.months.ago.to_date, end_date: nil, pay_level: 6)
      @msa2.destroy
      assert @msa2.destroyed?
      @cmu.destroy
    end
    
    #METHOD 'over_18?'
    should "shows that over_18? boolean method works" do
      assert @ed.over_18?
      assert_not_equal @cindy.over_18?, true
    end
    
    # METHOD 'age'
    should "shows that age method returns the correct value" do
      assert_equal 19, @ed.age
      assert_equal 17, @cindy.age
      assert_equal 30, @kathryn.age
    end
    
    should "show that an employee is not deleted if he work shifts" do
      @msa3 = FactoryBot.create(:employee, first_name: "m", last_name: "sa", ssn: "123-12-1234", date_of_birth: 19.years.ago.to_date)
      @cmu3 = FactoryBot.create(:store)
      @assignment_msa3 = FactoryBot.create(:assignment, employee: @msa3, store: @cmu3, start_date: 6.months.ago.to_date, end_date: nil, pay_level: 6)
      @shift = FactoryBot.create(:shift, assignment: @assignment_msa3)
      @shift_future = FactoryBot.create(:shift, assignment: @assignment_msa3, date: Date.today + 15.days)
      assert @msa3.worked_shift?
      @msa3.destroy
      assert !@msa3.destroyed?
      @cmu3.destroy
    end 
  end
end
