require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:shift_jobs)
  should have_many(:shifts).through(:shift_jobs)

  should validate_presence_of(:name)

  context "Creating a context for jobs" do
    setup do 
      create_jobs
    end
  
    teardown do
      remove_jobs
    end
    
    should "Show that there is one active job" do
      assert_equal 1, Job.active.size
      assert_equal ["Cleaner"], Job.active.map{|job| job.name}
    end
    
    should "Show that there is one inactive job" do
      assert_equal 1, Job.inactive.size
      assert_equal ["Cashier"], Job.inactive.map{|job| job.name}
    end

    should "List the positions in alphabetical order" do
      assert_equal 2, Job.alphabetical.size
      assert_equal ["Cashier", "Cleaner"], Job.alphabetical.map{|job| job.name}
    end
    
    should "Show that job can only be deleted if the job has never been worked by an employee; otherwise it is made inactive" do
      @test_store = FactoryBot.create(:store)
      @msa = FactoryBot.create(:employee, first_name: "Shahmeer", last_name: "Ahmad", role: "manager", phone: "123-123-1234")
      @assignment_msa = FactoryBot.create(:assignment, employee: @msa, store: @test_store, start_date: 6.months.ago.to_date, end_date: nil)
      @shift_msa = FactoryBot.create(:shift, assignment: @assignment_msa)
      @shift_job_clerk = FactoryBot.create(:shift_job, job: @cashier, shift: @shift_msa)
      @cashier.destroy
      
      assert_equal 1, Job.inactive.size
      assert_equal ["Cashier"], Job.inactive.map{|job| job.name}
      
      @shift_job_clerk.destroy
      @shift_msa.destroy
      @assignment_msa.destroy
      @msa.destroy
      @test_store.destroy
    end
    
  end
end
