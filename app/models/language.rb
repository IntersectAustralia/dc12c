class Language < ActiveRecord::Base
  attr_accessible :name, :code

  has_and_belongs_to_many :papyri

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true

  default_scope order: :name
end
