class Collection < ActiveRecord::Base
  include RIFCS::Collection

  attr_accessible :title, :description, :keywords, :papyrus_ids
  has_and_belongs_to_many :papyri

  validates_presence_of :title
  validates_uniqueness_of :title

  validates_presence_of :description
  validates_presence_of :keywords

  validates_length_of :title, maximum: 255
  validates_length_of :description, maximum: 512
  validates_length_of :keywords, maximum: 255

# required by RIFCS::Collection
  def collection_group
    "FIXME GROUP"
  end
  def collection_key
    "FIXME KEY"
  end
  def collection_originating_source
    "FIXME ORIGINATING SOURCE"
  end

  def collection_date_modified
    created_at
  end
  def collection_date_accessioned
    updated_at
  end

  def collection_type
    'FIXME TYPE'
  end
end
