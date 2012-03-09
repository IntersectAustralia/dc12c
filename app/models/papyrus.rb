class Papyrus < ActiveRecord::Base
  validates :inventory_id, presence: true, uniqueness: true

  validate :date_less_than_current_year
  validates_inclusion_of :date_era, in: ['BCE', 'CE'], allow_nil: true
  validates_numericality_of :date_year, greater_than: 0, allow_nil: true
  validates_presence_of :date_year, if: Proc.new {|papyrus| papyrus.date_era}
  validates_presence_of :date_era, if: Proc.new {|papyrus| papyrus.date_year}

  validates_numericality_of :width, greater_than: 0, allow_nil: true
  validates_numericality_of :height, greater_than: 0, allow_nil: true

  def formatted_date
    "#{date_year} #{date_era}" if date_year and date_era
  end

  private

  def date_less_than_current_year
    if date_era == 'CE' and date_year and date_year > Date.today.year
      self.errors[:base] << 'Date must be less than or equal to the current year'
    end
  end
end
