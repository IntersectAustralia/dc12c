class Connection < ActiveRecord::Base
  belongs_to :papyrus
  belongs_to :related_papyrus, class_name: 'Papyrus'

  validates_presence_of :papyrus_id
  validates_presence_of :related_papyrus_id

  validates_presence_of :description

  validates_uniqueness_of :related_papyrus_id, scope: :papyrus_id

  validates_length_of :description, maximum: 255

  validate :papyri_are_different

  default_scope order: 'description'

  private

  def papyri_are_different
    errors[:base] << "A papyri cannot be related to itself." unless (papyrus_id != related_papyrus_id && papyrus_id.present?)
  end

end
