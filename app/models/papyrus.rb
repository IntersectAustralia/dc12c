class Papyrus < ActiveRecord::Base

  VISIBLE = 'VISIBLE'
  PUBLIC = 'PUBLIC'
  HIDDEN = 'HIDDEN'

  belongs_to :country_of_origin, class_name: 'Country'
  belongs_to :genre
  has_and_belongs_to_many :languages

  validates :inventory_id, presence: true, uniqueness: true
  validates :visibility, presence: true, inclusion: [HIDDEN, VISIBLE, PUBLIC]

  validate :date_less_than_current_year
  validates_inclusion_of :date_era, in: ['BCE', 'CE'], allow_nil: true
  validates_numericality_of :date_year, greater_than: 0, allow_nil: true
  validates_presence_of :date_year, if: Proc.new {|papyrus| papyrus.date_era}
  validates_presence_of :date_era, if: Proc.new {|papyrus| papyrus.date_year}

  validates_numericality_of :width, greater_than: 0, allow_nil: true
  validates_numericality_of :height, greater_than: 0, allow_nil: true

  default_scope order: 'inventory_id'

  def formatted_date
    "#{date_year} #{date_era}" if date_year and date_era
  end

  def languages_csv
    languages.order("name").map(&:name).join(", ")
  end

  def human_readable_has_translation
    translated_text.present? ? 'Yes' : 'No'
  end

  private

  def date_less_than_current_year
    if date_era == 'CE' and date_year and date_year > Date.today.year
      self.errors[:base] << 'Date must be less than or equal to the current year'
    end
  end
end
