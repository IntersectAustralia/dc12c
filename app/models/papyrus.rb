require "unicode_utils/upcase"

class Papyrus < ActiveRecord::Base

  VISIBLE = 'VISIBLE'
  PUBLIC = 'PUBLIC'
  HIDDEN = 'HIDDEN'

  attr_accessible :inventory_id, :date_year, :date_era, :general_note, :note, :paleographic_description, :recto_note, :origin_details, :source_of_acquisition, :preservation_note, :summary, :language_note, :original_text, :translated_text, :verso_note, :width, :height, :country_of_origin_id, :genre_id, :language_ids

  belongs_to :country_of_origin, class_name: 'Country'
  belongs_to :genre
  has_and_belongs_to_many :languages
  has_many :access_requests
  has_many :images

  validates :inventory_id, presence: true, uniqueness: true
  validates :visibility, presence: true, inclusion: [HIDDEN, VISIBLE, PUBLIC]

  validate :date_less_than_current_year
  validates_inclusion_of :date_era, in: ['BCE', 'CE'], allow_nil: true
  validates_numericality_of :date_year, greater_than: 0, allow_nil: true
  validates_presence_of :date_year, if: Proc.new { |papyrus| papyrus.date_era }
  validates_presence_of :date_era, if: Proc.new { |papyrus| papyrus.date_year }

  validates_length_of :inventory_id, maximum: 32
  validates_length_of :date_year, maximum: 4
  validates_length_of :dimensions, maximum: 511
  validates_length_of :general_note, maximum: 255
  validates_length_of :note, maximum: 255
  validates_length_of :paleographic_description, maximum: 255
  validates_length_of :recto_note, maximum: 255
  validates_length_of :verso_note, maximum: 255
  validates_length_of :origin_details, maximum: 255
  validates_length_of :source_of_acquisition, maximum: 255
  validates_length_of :preservation_note, maximum: 255
  validates_length_of :summary, maximum: 255
  validates_length_of :language_note, maximum: 255
  validates_length_of :original_text, maximum: 4096
  validates_length_of :translated_text, maximum: 4096

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
    search_terms = search_terms.map {|term| "%#{UnicodeUtils.upcase(term)}%"}
    Papyrus.joins { languages.outer }.joins{country_of_origin.outer}.joins{genre.outer}.where do
      upper(inventory_id).like_any(search_terms)             \
    | upper(languages.name).like_any(search_terms)           \
    | upper(general_note).like_any(search_terms)             \
    | upper(note).like_any(search_terms)                     \
    | upper(paleographic_description).like_any(search_terms) \
    | upper(recto_note).like_any(search_terms)               \
    | upper(verso_note).like_any(search_terms)               \
    | upper(country_of_origin.name).like_any(search_terms)   \
    | upper(origin_details).like_any(search_terms)           \
    | upper(source_of_acquisition).like_any(search_terms)    \
    | upper(preservation_note).like_any(search_terms)        \
    | upper(genre.name).like_any(search_terms)               \
    | upper(language_note).like_any(search_terms)            \
    | upper(summary).like_any(search_terms)                  \
    | upper(translated_text).like_any(search_terms)
    end
  end

  def self.advanced_search search_fields

    search_fields = search_fields.reduce({}) do |acc, (k, v)|
      acc.merge k => v.split(/\s+/).map{|term| "%#{UnicodeUtils.upcase(term)}%"}
    end

    Papyrus.where do
      clauses = search_fields.map do |field_name, search_terms|
        upper(__send__(field_name)).like_any search_terms
      end
      clauses.reduce {|a, b| a | b }
    end
  end

  private

  def date_less_than_current_year
    if date_era == 'CE' and date_year and date_year > Date.today.year
      self.errors[:base] << 'Date must be less than or equal to the current year'
    end
  end
end
