class Job < ApplicationRecord
    # Callbacks
    before_delete :job_worked_by_employee
  
    #relationships
    has_many :shift_jobs
    has_many :shifts, through: :shift_jobs
    
    # Validations
    # make sure required fields are present
    validates_presence_of :name
    
    # Scopes
    scope :active,          -> { where(active: true) }
    scope :inactive,        -> { where(active: false) }
    scope :alphabetical,    -> { order('name') }
    
    # Callback code
    # -----------------------------
    private
    # can only be deleted if the job has never been worked by an employee; otherwise it is made inactive
    def job_worked_by_employee
      if job has never been worked by employee #no
        self.destroy
      else
        self.active = false
      end
    end
end
