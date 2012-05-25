class Collection < ActiveRecord::Base
  has_and_belongs_to_many :papyri

  validates_presence_of :title
  validates_uniqueness_of :title

  validates_presence_of :description
  validates_presence_of :keywords

  validates_length_of :title, maximum: 255
  validates_length_of :description, maximum: 512
  validates_length_of :keywords, maximum: 255
end
