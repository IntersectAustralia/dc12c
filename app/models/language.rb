class Language < ActiveRecord::Base
  attr_accessible :name

  has_and_belongs_to_many :papyri

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
end
