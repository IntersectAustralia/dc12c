class Name < ActiveRecord::Base
  belongs_to :papyrus

  attr_accessible :name, :role, :role_note, :added_information, :date, :ordering

  AUTHOR = 'AUT'
  ASSOCIATE = 'ASN'
  ROLE_OPTIONS = {'Author' => AUTHOR, 'Associate' => ASSOCIATE}

  validates_inclusion_of :role, in: ROLE_OPTIONS.values, allow_nil: true

  validates_presence_of :papyrus_id
  validates_presence_of :name

  validates_length_of :name, maximum: 64
  validates_length_of :role, maximum: 32
  validates_length_of :role_note, maximum: 127
  validates_length_of :added_information, maximum: 255
  validates_length_of :date, maximum: 255
  validates_length_of :ordering, maximum: 1

  validates_format_of :ordering, with: /[A-Z]/, allow_nil: true

  validates_uniqueness_of :name, scope: :papyrus_id

  default_scope order: 'ordering'

  before_validation :upcase_ordering

  def human_readable_role
    ROLE_OPTIONS.invert[role]
  end

  private

  def upcase_ordering
    if ordering
      self.ordering = ordering.to_s.upcase if ordering
    end
  end
end
