class Connection < ActiveRecord::Base
  belongs_to :papyrus
  belongs_to :related_papyrus, class_name: 'Papyrus'

  validates_presence_of :papyrus_id
  validates_presence_of :related_papyrus_id

  validates_presence_of :description

  validates_uniqueness_of :related_papyrus_id, scope: :papyrus_id

  validates_length_of :description, maximum: 255

  default_scope order: 'description'
end
