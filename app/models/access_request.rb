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

  scope :pending_requests, where(status: CREATED)
  scope :approved_requests, where(status: APPROVED)
  scope :rejected_requests, where(status: REJECTED)

  def approve!
    self.status = APPROVED
    self.save!
  end

  def reject!
    self.status = REJECTED
    self.save!
  end

  def self.place_request(user, papyrus)
    access_request = AccessRequest.new
    access_request.user = user
    access_request.papyrus = papyrus
    access_request.status = CREATED
    access_request.save!
    Notifier.notify_superusers_of_papyrus_access_request(access_request).deliver
  end
end
