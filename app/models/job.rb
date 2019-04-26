class Job < ApplicationRecord
    
    has_many :shift_jobs
    has_many :shifts, through: :shift_jobs
    
    validates_presence_of :name
    
    scope :active,          -> { where(active: true) }
    scope :inactive,        -> { where(active: false) }
    scope :alphabetical,    -> { order('name') }

    before_destroy :destroy_status_checker
    after_rollback :make_inactive
    
    def destroy_status_checker
      if !(self.shift_jobs.size <= 0)
          self.errors.add(:base, 'Cannot Destory: Job has been worked by an employee')
          throw(:abort)
      end
    end
    
    def make_inactive
        self.update_attribute(:active, false)
    end
end

