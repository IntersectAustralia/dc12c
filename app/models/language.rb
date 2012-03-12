class Language < ActiveRecord::Base
  has_and_belongs_to_many :papyri

  validates :name, presence: true, uniqueness: true
end