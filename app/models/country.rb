class Country < ActiveRecord::Base
  has_many :papyri

  validates :name, presence: true, uniqueness: true
end