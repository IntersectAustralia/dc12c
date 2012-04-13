require "unicode_utils/upcase"

class Papyrus < ActiveRecord::Base

  VISIBLE = 'VISIBLE'
  PUBLIC = 'PUBLIC'
  HIDDEN = 'HIDDEN'

  attr_accessible :mqt_number, :inventory_id, :date_from, :date_to, :date_note, :general_note, :lines_of_text, :paleographic_description, :recto_note, :origin_details, :source_of_acquisition, :preservation_note, :conservation_note, :summary, :language_note, :original_text, :translated_text, :verso_note, :dimensions, :country_of_origin_id, :genre_id, :language_ids, :other_characteristics, :material

  belongs_to :country_of_origin, class_name: 'Country'
  belongs_to :genre
  has_and_belongs_to_many :languages
  has_many :access_requests
  has_many :images

  validates :mqt_number, presence: true, uniqueness: true
  validates :visibility, presence: true, inclusion: [HIDDEN, VISIBLE, PUBLIC]

  validate :dates_in_range_and_non_zero
  validate :date_to_greater_than_date_from
  validates_numericality_of :date_from, greater_than: -10000, allow_nil: true
  validates_presence_of :date_from, if: proc { |papyrus| papyrus.date_to }

  validates_length_of :inventory_id, maximum: 32
  validates_length_of :dimensions, maximum: 511
  validates_length_of :general_note, maximum: 255
  validates_length_of :lines_of_text, maximum: 1023
  validates_length_of :paleographic_description, maximum: 1023
  validates_length_of :recto_note, maximum: 255
  validates_length_of :verso_note, maximum: 255
  validates_length_of :origin_details, maximum: 255
  validates_length_of :source_of_acquisition, maximum: 255
  validates_length_of :preservation_note, maximum: 1023
  validates_length_of :conservation_note, maximum: 1023
  validates_length_of :summary, maximum: 255
  validates_length_of :language_note, maximum: 255
  validates_length_of :original_text, maximum: 4096
  validates_length_of :translated_text, maximum: 4096
  validates_length_of :date_note, maximum: 511
  validates_length_of :other_characteristics, maximum: 1023
  validates_length_of :material, maximum: 255

  default_scope order: 'inventory_id'

  def date_from_year
    date_from.abs if date_from
  end

  def date_from_era
    to_era date_from
  end

  def date_to_year
    date_to.abs if date_to
  end

  def date_to_era
    to_era date_to
  end

  def formatted_date
    if date_from
      if date_to
        "#{date_from_year} #{date_from_era} - #{date_to_year} #{date_to_era}"
      else
        "#{date_from_year} #{date_from_era}"
      end
    end
  end

  def formatted_mqt_number
    "MQT #{mqt_number}"
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
    | upper(lines_of_text).like_any(search_terms)            \
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

  def date_to_greater_than_date_from
    if date_to and date_from
      errors[:date_to] << "Date to must be greater than Date from" unless date_to > date_from
    end
  end

  def dates_in_range_and_non_zero
    ['DateFrom', 'DateTo'].each do |field|
      method_name = field.underscore.to_sym
      field_value = self.send method_name
      if field_value
        errors[method_name] << "#{field.underscore.humanize} must not be zero" if field_value == 0
        errors[method_name] << "#{field.underscore.humanize} must be less than or equal to #{Date.today.year}" if field_value > Date.today.year
      end
    end
  end

  def to_era(date)
    if date
      date > 0 ? 'CE' : 'BCE'
    end
  end
end
