class Genre < ActiveRecord::Base
  has_many :papyri

  validates :name, presence: true, uniqueness: true
end