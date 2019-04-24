class Shift < ApplicationRecord
  # Callbacks
  before_create :end_time_three_hours
  
  #relationship
  belongs_to :assignment
  has_many :shift_jobs
  has_many :jobs, through: :shift_jobs
  
  # Validations
  # make sure required fields are present
  validates_presence_of :start_time
  validates_date :date
  validates_presence_of :assignment_id, on: :update
  #ensure that end_time is after start_time and that dates are either today or sometime in the future for new shifts
  validates_date :date, on_or_after: lambda { Date.current }, on_or_after_message: "should be in the future for new shifts"
  validates_time :end_time, after: :start_time, allow_blank: true
  #be added to only current assignments, not past assignments
  validate :assignment_is_current_in_system, on: :create
  validates_presence_of :assignment_id, on: :update
  
  # Scopes (store_id) { where("store_id = ?", store_id) }
  #scope :completed,       -> { where(count((job_id) {where(job_id) })>= 1) } #no
  scope :incomplete,       -> { where(end_date: nil) } #no
  scope :for_store,     ->(store_id) { where("store_id = ?", store_id) } 
  scope :for_employee,  ->(employee_id) { where("employee_id = ?", employee_id) }
  scope :past,          -> { where(start_date <= Date.current) }
  scope :upcoming,       -> { where(start_date >= Date.current) }
  scope :for_next_days,       ->(days) { where(start_date >= Date.current) } #no
  scope :for_past_days,       -> { where(end_date: nil) } #no
  scope :by_store,      -> { joins(:store).order('name') } 
  scope :by_employee,   -> { joins(:employee).order('last_name, first_name') }

  #methods
  def assignment_is_current_in_system
    all_current_assignments = Assignment.current.all.map{|e| e.id}
    unless all_current_assignments.include?(self.assignment_id)
      errors.add(:assignment_id, "is not an current assignment at the creamery")
    end
  end
  
  #have a method called 'completed?' 
  #which returns true or false depending on whether or not there are any jobs associated with that particular shift
  def completed?
    
  end
  
  #should have a method called 'start_now' which updates the shift's start time to be the current time in the database
  def start_now
    self.start_time = Time.now
  end
  
  #should have a method called 'end_now' which updates the shift's end time to be the current time in the database
  def end_now
    self.end_time = Time.now
  end
  
  # Callback code
  private
  #new shifts should have a callback which automatically sets the end time to three hours after the start time
  def end_time_three_hours
    self.end_time = 3 + self.start_time
  end
  
end