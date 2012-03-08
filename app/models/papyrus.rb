class Papyrus < ActiveRecord::Base
  validates :inventory_id, presence: true, uniqueness: true
end
