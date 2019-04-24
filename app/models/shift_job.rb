class ShiftJob < ApplicationRecord
  belongs_to :shift
  belongs_to :job
end
