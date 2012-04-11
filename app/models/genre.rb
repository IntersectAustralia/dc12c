class Genre < ActiveRecord::Base
  attr_accessible :name

  has_many :papyri

  validates :name, presence: true, uniqueness: true
end
