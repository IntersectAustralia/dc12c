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

  attr_accessible :mqt_number, :mqt_note, :inventory_number, :apis_id, :trismegistos_id, :physical_location, :date_from, :date_to, :date_note, :general_note, :lines_of_text, :paleographic_description, :origin_details, :source_of_acquisition, :preservation_note, :conservation_note, :summary, :language_note, :original_text, :translated_text, :dimensions, :genre_id, :language_ids, :other_characteristics, :material, :recto_verso_note, :type_of_text, :modern_textual_dates, :publications, :volume_number, :item_number, :keywords

  attr_field_security BASIC, :formatted_mqt_number, :inventory_number, :apis_id, :trismegistos_id, :formatted_date, :lines_of_text, :paleographic_description, :origin_details, :summary, :dimensions, :genre_name, :languages_csv, :material, :publications, :formatted_pmacq_number, :date_from, :date_to, :genre, :language_ids, :item_number, :mqt_number, :volume_number, :id

  attr_field_security DETAILED, :physical_location, :date_note, :general_note, :source_of_acquisition, :preservation_note, :conservation_note, :language_note, :translated_text, :other_characteristics, :type_of_text, :keywords

  attr_field_security FULL, :mqt_note, :original_text, :recto_verso_note, :modern_textual_dates

  belongs_to :genre
  has_and_belongs_to_many :languages
  has_many :access_requests, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :names, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_and_belongs_to_many :collections

  validates :mqt_number, presence: true, uniqueness: true
  validates :visibility, presence: true, inclusion: [HIDDEN, VISIBLE, PUBLIC]

  validate :dates_in_range_and_non_zero
  validate :date_to_greater_than_date_from
  validates_numericality_of :date_from, greater_than: -10000, allow_nil: true
  validates_presence_of :date_from, if: proc { |papyrus| papyrus.date_to }
  validates_numericality_of :trismegistos_id, greater_than: 0, allow_nil: true, only_integer: true

  validates_numericality_of :mqt_number, greater_than: 0, only_integer: true

  validates_length_of :mqt_note, maximum: 2048
  validates_length_of :inventory_number, maximum: 64
  validates_length_of :apis_id, maximum: 32
  validates_length_of :physical_location, maximum: 255
  validates_length_of :dimensions, maximum: 511
  validates_length_of :general_note, maximum: 512
  validates_length_of :lines_of_text, maximum: 1023
  validates_length_of :paleographic_description, maximum: 1023
  validates_length_of :origin_details, maximum: 255
  validates_length_of :source_of_acquisition, maximum: 255
  validates_length_of :preservation_note, maximum: 1023
  validates_length_of :conservation_note, maximum: 1023
  validates_length_of :summary, maximum: 1024
  validates_length_of :language_note, maximum: 255
  validates_length_of :original_text, maximum: 4000
  validates_length_of :translated_text, maximum: 4000
  validates_length_of :date_note, maximum: 511
  validates_length_of :other_characteristics, maximum: 1023
  validates_length_of :material, maximum: 255
  validates_length_of :recto_verso_note, maximum: 511
  validates_length_of :type_of_text, maximum: 255
  validates_length_of :modern_textual_dates, maximum: 511
  validates_length_of :publications, maximum: 511
  validates_length_of :keywords, maximum: 511

  validates_inclusion_of :volume_number, in: %w(I II III IV V VI VII VIII IX X), allow_nil: true
  validates_numericality_of :item_number, only_integer: true, allow_nil: true, greater_than: 0
  validates_uniqueness_of :item_number, allow_nil: true

  validates_presence_of :volume_number, if: :item_number
  validates_presence_of :item_number, if: :volume_number

  default_scope order: 'mqt_number'

  before_save do
    # If a user enters only a "date_from" it is considered to be an exact date.
    # The search_date_to field makes search code simpler
    if date_to
      self.search_date_to = date_to
    else
      self.search_date_to = date_from
    end
  end


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

  def language_codes_space_separated
    languages.order("name").map(&:code).join(" ")
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
          :trismegistos_id, :physical_location, :dimensions, :date_note, :conservation_note, :mqt_number,
          :other_characteristics, :material, :type_of_text, :translated_text]

    ability = Ability.new(user)
    registered, super_role, papyri_id_list = search_context(user)

    # genre.name, language.name are added by hand later
    results = Papyrus.joins { languages.outer }.joins{genre.outer}.where do
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
      end
      clauses << (upper(genre.name).like_any search_terms)
      clauses << (upper(languages.name).like_any search_terms)
      clauses.reduce {|a, b| a | b }
    end.uniq.accessible_by(ability, :search)
  end

  def self.advanced_search user, search_fields

    ability = Ability.new(user)
    registered, super_role, papyri_id_list = search_context(user)

    from = search_fields.delete(:date_from)
    to = search_fields.delete(:date_to)

    search_fields = search_fields.reduce({}) do |acc, (k, v)|
      acc.merge k.to_sym => v.split(/\s+/).map{|term| "%#{UnicodeUtils.upcase(term)}%"}
    end


    Papyrus.where do
      clauses = search_fields.map do |field_name, search_terms|
        ## this code couldn't be refactored :(
        if Papyrus.basic_field(field_name)
          upper(__send__(field_name)).like_all search_terms
        elsif Papyrus.detailed_field(field_name)
          if registered
            upper(__send__(field_name)).like_all search_terms
          else
            upper(__send__(field_name)).like_all(search_terms) & visibility.eq("PUBLIC")
          end
        else
          if super_role
            upper(__send__(field_name)).like_all search_terms
          else
            upper(__send__(field_name)).like_all(search_terms) & (visibility.eq("PUBLIC") | id.in(papyri_id_list))
          end
        end
      end
      clauses << (date_from.gte(from) | search_date_to.gte(from)) if from
      clauses << (date_from.lte(to) | search_date_to.lte(to)) if to
      clauses.reduce {|a, b| a & b }
    end.accessible_by(ability, :advanced_search)
  end

  def authors
    names.where(role: Name::AUTHOR).order('name')
  end

  def split_keywords
    if keywords
      keywords.split
    else
      []
    end
  end

  def anonymous_view
    case visibility
      when PUBLIC
        self
      when VISIBLE
        Papyrus.new do |p|
          BASIC.each do |method|
            assign_method = (method.to_s + '=')
            if p.respond_to? assign_method
              p.send(assign_method, self.send(method))
            end
          end
        end
      else raise "Cannot restricted_view papyrus with visibility #{visibility.inspect}"
    end
  end

# papyri.info XML functions
  def xml_date_from
    to_xml_date(date_from)
  end
  def xml_date_to
    to_xml_date(date_to)
  end
  def xml_title
    if type_of_text.present?
      type_of_text
    else
      formatted_mqt_number
    end
  end

  private

  def to_xml_date date
    # creates a date string suitable for use in a papyri.info-formatted XML document
    if date
# 4 digits, starting with a negative sign
# lstrip to remove the leading space in the case of a positive number
      ("% 05d" % date).lstrip
    end
  end

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

  def self.search_context user
    registered = user && user.role.present?
    super_role = user && (Role.superuser_roles.include? user.role)
    if user
      papyri_id_list = AccessRequest.where(user_id: user.id, status: AccessRequest::APPROVED).pluck(:papyrus_id)
    else
      papyri_id_list = []
    end
    [registered, super_role, papyri_id_list]
  end
end
