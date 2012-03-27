class AccessRequest < ActiveRecord::Base
  CREATED = 'CREATED'
  APPROVED = 'APPROVED'
  REJECTED = 'REJECTED'

  validates :status, inclusion: [CREATED, APPROVED, REJECTED]
  validates_presence_of :user_id
  validates_presence_of :papyrus_id
  validates_uniqueness_of :user_id, scope: :papyrus_id

  belongs_to :user
  belongs_to :papyrus

  def self.place_request(user, papyrus)
    Notifier.notify_superusers_of_papyrus_access_request(user, papyrus)
    create!(user: user, papyrus: papyrus, status: CREATED)
  end
end
