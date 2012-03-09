class Papyrus < ActiveRecord::Base
  validates :inventory_id, presence: true, uniqueness: true
  
  def formatted_date
    "#{date_year} #{date_era}" if date_year and date_era
  end
end
