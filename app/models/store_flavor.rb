class StoreFlavor < ApplicationRecord
  belongs_to :store
  belongs_to :flavor
end
