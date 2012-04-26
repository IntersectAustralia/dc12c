require "unicode_utils/upcase"
require 'set'

class Papyrus < ActiveRecord::Base

  BASIC = Set.new
  DETAILED = Set.new
  FULL = Set.new

  private

  def self.attr_field_security(set, *method_names)
    set.merge(method_names)
  end

  public

  VISIBLE = 'VISIBLE'
  PUBLIC = 'PUBLIC'
  HIDDEN = 'HIDDEN'

  attr_accessible :mqt_number, :mqt_note, :inventory_number, :apis_id, :trismegistos_id, :physical_location, :date_from, :date_to, :date_note, :general_note, :lines_of_text, :paleographic_description, :origin_details, :source_of_acquisition, :preservation_note, :conservation_note, :summary, :language_note, :original_text, :translated_text, :dimensions, :genre_id, :language_ids, :other_characteristics, :material, :recto_verso_note, :type_of_text, :modern_textual_dates, :publications, :volume_number, :item_number

  attr_field_security BASIC, :formatted_mqt_number, :inventory_number, :apis_id, :trismegistos_id, :formatted_date, :lines_of_text, :paleographic_description, :origin_details, :summary, :dimensions, :genre_name, :languages_csv, :material, :publications, :formatted_pmacq_number

  attr_field_security DETAILED, :physical_location, :date_note, :general_note, :source_of_acquisition, :preservation_note, :conservation_note, :language_note, :translated_text, :other_characteristics, :type_of_text

  attr_field_security FULL, :mqt_note, :original_text, :recto_verso_note, :modern_textual_dates

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
  validates_numericality_of :trismegistos_id, greater_than: 0, allow_nil: true, only_integer: true

  validates_numericality_of :mqt_number, greater_than: 0, only_integer: true

  validates_length_of :mqt_note, maximum: 255
  validates_length_of :inventory_number, maximum: 32
  validates_length_of :apis_id, maximum: 32
  validates_length_of :physical_location, maximum: 255
  validates_length_of :dimensions, maximum: 511
  validates_length_of :general_note, maximum: 255
  validates_length_of :lines_of_text, maximum: 1023
  validates_length_of :paleographic_description, maximum: 1023
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
  validates_length_of :recto_verso_note, maximum: 511
  validates_length_of :type_of_text, maximum: 255
  validates_length_of :modern_textual_dates, maximum: 511
  validates_length_of :publications, maximum: 511

  validates_inclusion_of :volume_number, in: %w(I II III IV V VI VII VIII IX X), allow_nil: true
  validates_numericality_of :item_number, only_integer: true, allow_nil: true, greater_than: 0
  validates_uniqueness_of :item_number, allow_nil: true

  validates_presence_of :volume_number, if: :item_number
  validates_presence_of :item_number, if: :volume_number

  default_scope order: 'mqt_number'

  def self.basic_field(field_name)
    BASIC.include? field_name
  end

  def self.detailed_field(field_name)
    DETAILED.include? field_name
  end

  def self.full_field(field_name)
    FULL.include? field_name
  end

  def formatted_pmacq_number
    "#{volume_number} #{item_number}" if volume_number and item_number
  end

  def make_hidden!
    self.visibility = HIDDEN
    self.save!
  end

  def make_public!
    self.visibility = PUBLIC
    self.save!
  end

  def make_visible!
    self.visibility = VISIBLE
    self.save!
  end

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

  def genre_name
    genre.name if genre
  end

  def self.search user, search_terms
    search_terms = search_terms.map {|term| "%#{UnicodeUtils.upcase(term)}%"}
    simple_fields = [:inventory_number, :general_note, :lines_of_text,
          :paleographic_description, :recto_verso_note, :origin_details, :source_of_acquisition,
          :preservation_note, :language_note, :summary, :mqt_note, :apis_id,
          :trismegistos_id, :physical_location, :dimensions, :date_note, :conservation_note,
          :other_characteristics, :material, :type_of_text, :translated_text]
    ability = Ability.new(user)
    registered = user and user.role.present?
    super_role = user and (Role.superuser_roles.include? user.role)
    if user
      papyri_id_list = AccessRequest.where(user_id: user.id, status: AccessRequest::APPROVED).pluck(:papyrus_id)
    else
      papyri_id_list = []
    end
    # genre.name, language.name are added by hand later
    Papyrus.joins { languages.outer }.joins{genre.outer}.where do
      clauses = simple_fields.map do |field_name|
        if Papyrus.basic_field(field_name)
           upper(__send__(field_name)).like_any search_terms
        elsif Papyrus.detailed_field(field_name)
          if registered
           upper(__send__(field_name)).like_any search_terms
          else
           upper(__send__(field_name)).like_any(search_terms) & visibility.eq("PUBLIC")
          end
        else
          if super_role
            upper(__send__(field_name)).like_any search_terms
          else
            upper(__send__(field_name)).like_any(search_terms) & (visibility.eq("PUBLIC") | id.in(papyri_id_list))
          end
        end
      end.compact
      clauses << (upper(genre.name).like_any search_terms)
      clauses << (upper(languages.name).like_any search_terms)
      clauses.reduce {|a, b| a | b }
    end.accessible_by(ability, :search)
  end

  def self.advanced_search user, search_fields

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

#  def inspect
#    modern_textual_dates
#  end

  private

  def date_to_greater_than_date_from
    if date_to and date_from
      errors[:date_to] << "must be greater than Date from" unless date_to > date_from
    end
  end

  def dates_in_range_and_non_zero
    ['DateFrom', 'DateTo'].each do |field|
      method_name = field.underscore.to_sym
      field_value = self.send method_name
      if field_value
        errors[method_name] << "must not be zero" if field_value == 0
        errors[method_name] << "must be less than or equal to #{Date.today.year}" if field_value > Date.today.year
      end
    end
  end

  def to_era(date)
    if date
      date > 0 ? 'CE' : 'BCE'
    end
  end
end
