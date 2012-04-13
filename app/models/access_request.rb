class AccessRequest < ActiveRecord::Base
  CREATED = 'CREATED'
  APPROVED = 'APPROVED'
  DATE_FORMAT = '%Y-%m-%d'

  validates :status, inclusion: [CREATED, APPROVED]
  validates_presence_of :user_id
  validates_presence_of :papyrus_id
  validates_uniqueness_of :user_id, scope: :papyrus_id
  validates_presence_of :date_requested
  validates_presence_of :date_approved, if: proc{|access_request| access_request.status == APPROVED}

  validate :dates_less_than_current_time
  validate :date_approved_greater_than_date_requested

  belongs_to :user
  belongs_to :papyrus

  scope :pending_requests, where(status: CREATED).order('date_requested asc')
  scope :approved_requests, where(status: APPROVED).order('date_approved desc')

  def approve!
    self.status = APPROVED
    self.date_approved = Time.now
    self.save!
  end

  def reject!
    self.destroy
  end

  def self.place_request(user, papyrus)
    access_request = AccessRequest.new
    access_request.user = user
    access_request.papyrus = papyrus
    access_request.status = CREATED
    access_request.date_requested = Date.today
    access_request.save!

    Notifier.notify_superusers_of_papyrus_access_request(access_request).deliver
  end

  def formatted_date_approved
    date_approved.localtime.strftime(DATE_FORMAT)
  end

  def formatted_date_requested
    date_requested.localtime.strftime(DATE_FORMAT)
  end

  private

  def dates_less_than_current_time
    [:date_requested, :date_approved].each do |date_field|
      date_value = self.send date_field

      if date_value and date_value > Time.now
        errors.add(date_field, "#{date_field} must be less than now")
      end
    end
  end

  def date_approved_greater_than_date_requested
    if date_approved and date_requested
      if date_approved <= date_requested
        errors.add(:date_approved, 'Date approved must be greater than date requested')
      end
    end
  end

end
