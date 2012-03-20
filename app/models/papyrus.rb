class Papyrus < ActiveRecord::Base

  VISIBLE = 'VISIBLE'
  PUBLIC = 'PUBLIC'
  HIDDEN = 'HIDDEN'

  belongs_to :country_of_origin, class_name: 'Country'
  belongs_to :genre
  has_and_belongs_to_many :languages
  has_many :access_requests

  validates :inventory_id, presence: true, uniqueness: true
  validates :visibility, presence: true, inclusion: [HIDDEN, VISIBLE, PUBLIC]

  validate :date_less_than_current_year
  validates_inclusion_of :date_era, in: ['BCE', 'CE'], allow_nil: true
  validates_numericality_of :date_year, greater_than: 0, allow_nil: true
  validates_presence_of :date_year, if: Proc.new { |papyrus| papyrus.date_era }
  validates_presence_of :date_era, if: Proc.new { |papyrus| papyrus.date_year }

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

  def self.search search_terms
    search_terms = search_terms.map {|term| "%#{term}%"}
    Papyrus.joins { languages.outer }.joins{country_of_origin.outer}.joins{genre.outer}.where { inventory_id.like_any(search_terms)  \
    | languages.name.like_any(search_terms)                                         \
    | general_note.like_any(search_terms)                                           \
    | note.like_any(search_terms)                                                   \
    | paleographic_description.like_any(search_terms)                               \
    | recto_note.like_any(search_terms)                                             \
    | verso_note.like_any(search_terms)                                             \
    | country_of_origin.name.like_any(search_terms)                                 \
    | origin_details.like_any(search_terms)                                         \
    | source_of_acquisition.like_any(search_terms)                                  \
    | preservation_note.like_any(search_terms)                                      \
    | genre.name.like_any(search_terms)                                             \
    | language_note.like_any(search_terms)                                          \
    | summary.like_any(search_terms)                                                \
    | translated_text.like_any(search_terms) }

  end

  def self.advanced_search search_fields

    search_fields = search_fields.reduce({}) do |acc, (k, v)|
      acc.merge k => v.split(/\s+/).map{|term| "%#{term}%"}
    end

    Papyrus.where do |p|
      clauses = search_fields.map do |field_name, search_terms|
        p.__send__(field_name).like_any search_terms
      end
      clauses_orred_together = clauses.first
      clauses.each.with_index do |clause, index|
        if index != 0
          clauses_orred_together |= clause
        end
      end
      clauses_orred_together
    end
  end

  private

  def date_less_than_current_year
    if date_era == 'CE' and date_year and date_year > Date.today.year
      self.errors[:base] << 'Date must be less than or equal to the current year'
    end
  end
end
